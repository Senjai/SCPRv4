class RemoveOrphanRecords < ActiveRecord::Migration
  def up
    versions  = []
    assets    = []
    homepage  = []
    missedit  = []
    comments  = []
    links     = []
    audio     = []
    related   = []
    bylines   = []

    Secretary::Version.find_in_batches do |group|
      group.each do |item|
        if item.versioned.blank?
          item.destroy
          versions << item.id
        end
      end
    end

    ContentAsset.find_in_batches do |group|
      group.each do |item|
        if item.content.blank?
          item.destroy
          assets << item.id 
        end
      end
    end

    HomepageContent.find_in_batches do |group|
      group.each do |item|
        if item.content.blank?
          item.destroy
          homepage << item.id
        end
      end
    end

    MissedItContent.find_in_batches do |group|
      group.each do |item|
        if item.content.blank?
          item.destroy
          missedit << item.id
        end
      end
    end

    FeaturedComment.find_in_batches do |group|
      group.each do |item|
        if item.content.blank?
          item.destroy
          comments << item.id
        end
      end
    end

    Audio.find_in_batches do |group|
      group.each do |item|
        if item.content.blank?
          item.destroy
          audio << item.id
        end
      end
    end

    RelatedLink.find_in_batches do |group|
      group.each do |item|
        if item.content.blank?
          item.destroy
          links << item.id
        end
      end
    end

    Related.find_in_batches do |group|
      group.each do |item|
        if item.content.blank? || item.related.blank?
          item.destroy
          related << item.id
        end
      end
    end

    ContentByline.find_in_batches do |group|
      group.each do |item|
        if item.content.blank?
          item.destroy
          bylines << item.id
        end
      end
    end

    $stdout.puts "Version: (#{versions.size} total) #{versions}"
    $stdout.puts "ContentAsset: (#{assets.size} total) #{assets}"
    $stdout.puts "HomepageContent: (#{homepage.size} total) #{homepage}"
    $stdout.puts "MissedItContent: (#{missedit.size} total) #{missedit}"
    $stdout.puts "FeaturedComment: (#{comments.size} total) #{comments}"
    $stdout.puts "RelatedLink: (#{links.size} total) #{links}"
    $stdout.puts "Audio: (#{audio.size} total) #{audio}"
    $stdout.puts "Related: (#{related.size} total) #{related}"
    $stdout.puts "ContentByline: (#{bylines.size} total) #{bylines}"
  end

  def down
  end
end
