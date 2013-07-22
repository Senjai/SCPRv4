class UpdateVersionsForExternalPrograms < ActiveRecord::Migration
  def up
    Secretary::Version.where(versioned_type: "OtherProgram").update_all(versioned_type: "ExternalProgram")
  end

  def down
    Secretary::Version.where(versioned_type: "ExternalProgram").update_all(versioned_type: "OtherProgram")
  end
end
