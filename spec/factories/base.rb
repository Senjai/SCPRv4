def content_base_associations(object, evaluator)
  FactoryGirl.create_list(:asset,   evaluator.asset_count.to_i,   content: object)
  FactoryGirl.create_list(:link,    evaluator.link_count.to_i,    content: object)
  FactoryGirl.create_list(:brel,    evaluator.brel_count.to_i,    content: object)
  FactoryGirl.create_list(:frel,    evaluator.frel_count.to_i,    related: object)
  FactoryGirl.create_list(:byline,  evaluator.byline_count.to_i,  content: object)
  
  if evaluator.category_type.present? && evaluator.with_category
    category = FactoryGirl.create(evaluator.category_type)
    FactoryGirl.create(:content_category, content: object, category: category)
  end
end

FactoryGirl.define do
  ### Common Attributes
  trait :sequenced_published_at do
    sequence(:published_at) { |n| Time.now + 60*60*n }
  end
end