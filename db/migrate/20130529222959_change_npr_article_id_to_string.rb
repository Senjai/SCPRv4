class ChangeNprArticleIdToString < ActiveRecord::Migration
  def up
    change_column :remote_articles, :article_id, :string
  end

  def down
    change_column :remote_articles, :article_id, :integer
  end
end
