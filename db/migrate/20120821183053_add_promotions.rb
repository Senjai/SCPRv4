class AddPromotions < ActiveRecord::Migration
  def change
    create_table "promotions" do |t|
      t.string  "title"
      t.string  "url"
      t.integer "asset_id"
      t.timestamps
    end
  end
end
