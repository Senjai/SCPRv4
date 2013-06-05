class ConvertQueryUrlToQueryId < ActiveRecord::Migration
  def up
    PijQuery.all.each do |query|
      m = query.query_url.match(Regexp.union(
            /form_code=(?<id>[a-zA-Z0-9]+)/,
            /form\/.+?\/(?<id>[a-zA-Z0-9]+)/,
            /iframe\/(?<id>[a-zA-Z0-9]+)/
          ))

      query.update_attribute(:pin_query_id, m[:id])
    end
  end

  def down
    PijQuery.update_all(pin_query_id: nil)
  end
end
