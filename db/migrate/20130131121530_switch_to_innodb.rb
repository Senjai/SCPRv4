class SwitchToInnodb < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.tables.each do |table|
      execute "alter table #{table} engine=InnoDB"
    end
  end

  def down
    # nope
  end
end
