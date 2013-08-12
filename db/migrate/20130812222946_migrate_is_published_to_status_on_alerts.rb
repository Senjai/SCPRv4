class MigrateIsPublishedToStatusOnAlerts < ActiveRecord::Migration
  def up
    BreakingNewsAlert.all.each do |a|
      if a.is_published?
        a.update_column(:status, BreakingNewsAlert::STATUS_PUBLISHED)
      else
        a.update_column(:status, BreakingNewsAlert::STATUS_DRAFT)
      end
    end
  end

  def down
  end
end
