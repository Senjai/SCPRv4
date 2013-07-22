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
    ExternalProgram.all.each do |ext_program|
      if npr_program = NPR_PROGRAMS.find { |npr| npr[:local_id] == ext_program.id }
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
