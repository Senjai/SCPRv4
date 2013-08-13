class RemoveHtmlFromAbstractSummaries < ActiveRecord::Migration
  def up
    Abstract.all.each do |abstract|
      frag = Nokogiri::HTML::DocumentFragment.parse(abstract.summary.gsub(/&mdash;/, "-"))
      abstract.update_column(:summary, frag.content)
    end
  end

  def down
  end
end
