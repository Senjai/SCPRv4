class CreateVersions < ActiveRecord::Migration
  def change
    create_table "versions" do |t|
      t.integer   "version_number"
      t.string    "versioned_type"
      t.integer   "versioned_id"
      t.string    "user_id"
      t.text      "description"
      t.text      "object_yaml"
      t.datetime  "created_at"
    end
  end
end
