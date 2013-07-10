class ChangeRemoteArticlesTable < ActiveRecord::Migration
  def up
    rename_column :remote_articles, :type, :importer_type

    RemoteArticle.where(importer_type: "NprArticle").find_in_batches do |group|
      group.each do |article|
        article.update_column(:importer_type, "NprArticleImporter")
      end
    end

    RemoteArticle.where(importer_type: "ChrArticle").find_in_batches do |group|
      group.each do |article|
        article.update_column(:importer_type, "ChrArticleImporter")
      end
    end

  end

  def down
    rename_column :remote_articles, :importer_type, :type

    RemoteArticle.where(type: "NprArticleImporter").find_in_batches do |group|
      group.each do |article|
        article.update_column(:type, "NprArticle")
      end
    end

    RemoteArticle.where(type: "ChrArticleImporter").find_in_batches do |group|
      group.each do |article|
        article.update_column(:type, "ChrArticle")
      end
    end
  end
end
