require 'spec_helper'

describe ContentBase do
  ContentBase.content_classes.each do |c|
    describe c do      
      it "inherits from ContentBase" do
        object = build c.to_s.underscore.to_sym
        object.is_a?(ContentBase).should be_true
      end
      
      it "can limit by published content" do
        published = create_list c.to_s.underscore.to_sym, 3, status: 5
        unpublished = create_list c.to_s.underscore.to_sym, 2, status: 4
        c.published.count.should eq 3
      end
      
      it "orders published content by published_at (or pub_at) descending" do
          objects = create_list c.to_s.underscore.to_sym, 3, status: 5
          c.published.first.should eq objects.last
          c.published.last.should eq objects.first
      end
      
      it "must return a headline" do
        object = build c.to_s.underscore.to_sym
        object.headline.should_not be_nil
      end
      
      it "must return a short_headline" do
        object = build c.to_s.underscore.to_sym
        object.short_headline.should_not be_nil
      end
      
      it "must return a teaser" do
        object = build c.to_s.underscore.to_sym
        object.teaser.should_not be_nil
      end
      
      it "must have a byline_elements attribute/method" do
        object = build c.to_s.underscore.to_sym
        object.should respond_to :byline_elements
      end
      
      it "must return byline_elements as an array" do
        object = build c.to_s.underscore.to_sym
        object.byline_elements.should be_a Array
      end
      
      it "can generate a link_path" do
        object = create c.to_s.underscore.to_sym
        object.link_path.should_not be_nil
      end
    end
  end
end