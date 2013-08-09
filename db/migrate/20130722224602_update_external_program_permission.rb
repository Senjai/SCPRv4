class UpdateExternalProgramPermission < ActiveRecord::Migration
  def up
    p = Permission.find_by_resource("OtherProgram")
    p.update_column(:resource, "ExternalProgram")
  end

  def down
    p = Permission.find_by_resource("ExternalProgram")
    p.update_column(:resource, "OtherProgram")
  end
end
