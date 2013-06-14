class CleanupContentshells < ActiveRecord::Migration
  def up
    ContentShell.where("site = ? or site = ?", "KPCC's blogdowntown", "blogdowntown").each do |c|
      c.update_column(:site, "blogdowntown")
    end

    ContentShell.where("site = ? or site = ?", "KPCC\'s MultiAmerican", "Mult-American").each do |c|
      c.update_column(:site, "Multi-American")
    end

    change_table :contentbase_contentshell do |t|
      t.change :headline, :string, null: true, limit: 255
      t.change :site, :string, null: true, default: nil, limit: 255
      t.change :url, :string, null: true, default: nil, limit: 255
    end

    add_index :contentbase_contentshell, :site
  end

  def down
  end
end
