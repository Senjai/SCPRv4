BlogEntry.where("body = '' or body is null or teaser = '' or teaser is null or short_headline = '' or short_headline is null").where(status: [4, 5]).find_in_batches do |group|
  group.each do |obj|
    if obj.body.blank?
      obj.update_column(:body, "<p>#{obj.blog.name}</p>")
    end

    if obj[:teaser].blank?
      teaser = ContentBase.generate_teaser(obj.body)
      obj.update_column(:teaser, teaser.present? ? teaser : obj.blog.name)
    end

    if obj[:short_headline].blank?
      obj.update_column(:short_headline, obj.headline)
    end
  end
end

NewsStory.where("body = '' or body is null or teaser = '' or teaser is null or short_headline = '' or short_headline is null").where(status: [4, 5]).find_in_batches do |group|
  group.each do |obj|
    if obj.body.blank?
      obj.update_column(:body, "<p>KPCC</p>")
    end

    if obj[:teaser].blank?
      teaser = ContentBase.generate_teaser(obj.body)
      obj.update_column(:teaser, teaser.present? ? teaser : "KPCC")
    end

    if obj[:short_headline].blank?
      obj.update_column(:short_headline, obj.headline)
    end
  end
end

ShowSegment.where("body = '' or body is null or teaser = '' or teaser is null or short_headline = '' or short_headline is null").where(status: [4, 5]).find_in_batches do |group|
  group.each do |obj|
    if obj.body.blank?
      obj.update_column(:body, "<p>#{obj.show.title}</p>")
    end

    if obj[:teaser].blank?
      teaser = ContentBase.generate_teaser(obj.body)
      obj.update_column(:teaser, teaser.present? ? teaser : obj.show.title)
    end

    if obj[:short_headline].blank?
      obj.update_column(:short_headline, obj.headline)
    end
  end
end

Event.where("body = '' or body is null or teaser = '' or teaser is null").where(status: [4, 5]).find_in_batches do |group|
  group.each do |obj|
    if obj.body.blank?
      obj.update_column(:body, "<p>#{obj.headline}</p>")
    end

    if obj[:teaser].blank?
      teaser = ContentBase.generate_teaser(obj.body)
      obj.update_column(:teaser, teaser.present? ? teaser : obj.headline)
    end
  end
end
