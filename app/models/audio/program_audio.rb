##
# ProgramAudio
#
# Created automatically
# when the file appears on the filesystem
# It belongs to a ShowEpisode or ShowSegment
# for a KpccProgram
#
# Doesn't need an instance `#sync` method,
# because an instance is only created if
# the audio exists.
#
class Audio
  class ProgramAudio < Audio
    include Audio::Paths
    include Audio::FileInfo

    extend LogsAsTask
    logs_as_task

    # 20121001_mbrand.mp3
    FILENAME_REGEX = %r{(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_(?<slug>\w+)\.mp3}

    before_create :set_description_to_episode_headline, if: -> {
      self.description.blank?
    }

    #------------

    class << self
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      def default_status
        STATUS_LIVE
      end

      #------------
      # TODO This could be broken up into smaller units
      # Since this is run as a task, we need some informative
      # logging in case of failure, hence the begin/rescue block.
      def bulk_sync
        # Each KpccProgram with episodes and which can sync audio
        KpccProgram.can_sync_audio.each do |program|
          begin
            # Each file in this program's audio directory
            Dir.foreach(program.absolute_audio_path).each do |file|
              absolute_mp3_path = File.join(program.absolute_audio_path, file)

              # Move on if:
              # 1. The file is too old -
              #    To keep this process quick, only
              #    worry about files less than 14 days old
              file_date = File.mtime(absolute_mp3_path)
              next if file_date < 14.days.ago

              # 1. File already exists (program audio only needs to exist once in the DB)
              next if existing[File.join(program.audio_dir, file)]

              # 2. The filename doesn't match our regex (won't be able to get date)
              match = file.match(FILENAME_REGEX)
              next if !match

              # Get the date for this episode/segment based on the filename,
              # find that episode/segment, and create the audio / association
              # if the content for that date exists.
              date = Time.new(match[:year], match[:month], match[:day])

              if program.display_episodes?
                content = program.episodes.for_air_date(date).first
              else
                content = program.segments.where(published_at: date..date.end_of_day).first
              end

              if content
                audio = self.new(content: content)
                audio.send :write_attribute, :mp3, file
                synced << audio if audio.save!
                self.log "Saved ProgramAudio ##{audio.id} for #{content.simple_title}"
              end
            end # Dir

          rescue => e
            self.log "Could not save ProgramAudio: #{e}"
            NewRelic.log_error(e)
            next
          end
        end # KpccProgram

        self.log "Finished syncing ProgramAudio. Total synced: #{synced.size}"
        synced
      end # bulk_sync

      add_transaction_tracer :bulk_sync, category: :task

      #------------

      private

      #------------
      # Setup a hash to search so we only have to
      # perform one query to check for existance
      def existing
        @existing ||= begin
          existing_hash = {}
          Audio::ProgramAudio.all.each { |a| existing_hash[a.path] = true }
          existing_hash
        end
      end

      #------------------------
      # An array of what got synced
      def synced
        @synced ||= []
      end
    end # singleton


    def store_dir
      self.content.show.audio_dir
    end

    # We store this in the "mp3" column because we want to
    # be able to, and can, detect the audio automatically without
    # having to store the info in the audio table.
    def filename
      self.mp3.file.filename
    end

    def mp3_file
      self.mp3.file.file
    end


    private

    def set_description_to_episode_headline
      self.description = self.content.headline
    end
  end # ProgramAudio
end # Audio
