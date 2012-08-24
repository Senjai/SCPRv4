class CreateSectionPromotions < ActiveRecord::Migration
  def change
    create_table :section_promotions do |t|
      t.integer :section_id
      t.integer :promotion_id
      t.timestamps
    end
  end
end
