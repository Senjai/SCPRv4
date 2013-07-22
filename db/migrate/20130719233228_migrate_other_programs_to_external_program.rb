class OtherProgram < ActiveRecord::Base
  self.table_name = "programs_otherprogram"
end

class MigrateOtherProgramsToExternalProgram < ActiveRecord::Migration
  NPR_PROGRAMS = [
    { local_id: 23, external_id: 2 }, # ATC
    { local_id: 25, external_id: 13 }, # Fresh Air
    { local_id: 26, external_id: 3 }, # Morning Edition
    { local_id: 27, external_id: 61 }, # Science Friday
    { local_id: 28, external_id: 5 }, # TOTN
    { local_id: 29, external_id: 35 }, # Wait Wait
    { local_id: 30, external_id: 7 }, # WE Sat
    { local_id: 31, external_id: 10 }, # WE Sun
#    { local_id: 37, external_id: 0 }, # Snap Judgement
    { local_id: 41, external_id: 46 }, # Tell Me More
    { local_id: 42, external_id: 57 }, # TED Radio
    { local_id: 45, external_id: 58 } # Ask Me Another
#    { local_id: 16, external_id: 0 }, # On the Media
  ]

  def up
    OtherProgram.all.each do |p|
      ext_program = ExternalProgram.new(
        :id             => p.id,
        :slug           => p.slug,
        :title          => p.title,
        :teaser         => p.teaser,
        :description    => p.description,
        :host           => p.host,
        :organization   => p.produced_by,
        :airtime        => p.airtime,
        :air_status     => p.air_status,
        :web_url        => p.web_url,
        :podcast_url    => p.podcast_url,
        :rss_url        => p.rss_url,
        :sidebar        => p.sidebar,
        :created_at     => p.created_at
      )

      if npr_program = NPR_PROGRAMS.find { |npr| npr[:local_id] == p.id }
        ext_program.external_id = npr_program[:external_id]
        ext_program.is_episodic = true
        ext_program.source = "npr-api"
      else
        ext_program.is_episodic = false
        ext_program.source = "rss"
      end

      ext_program.save!
    end
  end

  def down
  end
end
