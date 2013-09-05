class ChangeDatabaseEncodingDefualts < ActiveRecord::Migration
  DB = ActiveRecord::Base.connection.current_database

  def up
    execute("alter database #{DB} character set utf8 collate utf8_general_ci;")

    ActiveRecord::Base.connection.tables.each do |table|
      execute("alter table #{table} convert to character set utf8 collate utf8_general_ci;")
    end
  end

  def down
    execute("alter database #{DB} convert to character set latin1;")

    ActiveRecord::Base.connection.tables.each do |table|
      execute("alter table #{table} convert to character set latin1;")
    end
  end
end
