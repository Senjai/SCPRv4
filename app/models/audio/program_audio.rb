## 
# ProgramAudio
#
# Created automatically
# when the file appears on the filesystem
# It belongs to a ShowEpisode or ShowSegment
# for a KpccProgram
#
# Doesn't need an instance `#sync!` method,
# because an instance is only created if
# the audio exists.
#
class Audio
  class ProgramAudio < Audio
    extend LogsAsTask
    logs_as_task
    
    before_create :set_description_to_episode_headline, if: -> { self.description.blank? }
  
    def set_description_to_episode_headline
      self.description = self.content.headline
    end

    #------------
    
    class << self
      def store_dir(audio)
        audio.content.show.audio_dir
      end
  
      def filename(audio)
        audio.mp3.file.filename
      end
  
      #------------
      # TODO This could be broken up into smaller units
      # Since this is run as a task, we need some informative
      # logging in case of failure, hence the begin/rescue block.
      def bulk_sync!
        begin
          # Each KpccProgram with episodes and which can sync audio
          KpccProgram.can_sync_audio.each do |program|
            # Each file in this program's audio directory
            Dir[program.absolute_audio_path].each do |file|
              absolute_mp3_path = File.join(program.absolute_audio_path, file)
        
              # Move on if:
              # 1. File already exists (program audio only needs to exist once in the DB)
              next if existing[File.join(program.audio_dir, file)]
        
              # 2. The filename doesn't match our regex (won't be able to get date)
              match = file.match(FILENAMES[:program])
              next if !match
            
              # 3. The file is too old -
              #    If the file was uploaded more than 14 days ago
              #    and still hasn't been matched, then something's wrong.
              #    Maybe the date is incorrect? Either way, at this point
              #    it's too old to keep trying. They can upload the audio
              #    manually if they need to.
              file_date = File.mtime(absolute_mp3_path)
              next if file_date < 14.days.ago

              # Get the date for this episode/segment based on the filename,
              # find that episode/segment, and create the audio / association
              # if the content for that date exists.
              date = Time.new(match[:year], match[:month], match[:day])
        
              if program.display_episodes?
                content = program.episodes.where(air_date: date).first
              else
                content = program.segments.where(published_at: date..date.end_of_day).first
              end
        
              if content
                audio = self.new(content: content, mp3: File.open(absolute_mp3_path))
                synced << audio if audio.save!
                self.log "Saved ProgramAudio ##{audio.id} for #{content.simple_title}"
              end
            end # Dir
          end # KpccProgram
          
        rescue Exception => e
          self.log "Could not save ProgramAudio: #{e}"
        end
        
        self.log "Finished syncing ProgramAudio. Total synced: #{synced.size}"
        synced
      end # sync!
    
      #------------
  
      # Setup a hash to search so we only have to
      # perform one query to check for existance
      def existing
        @existing ||= Audio.all.map { |a| existing[a.path] = true }
      end

      # An array of what got synced
      def synced
        @synced ||= []
      end
    end # singleton
  end # ProgramAudio
end # Audio
