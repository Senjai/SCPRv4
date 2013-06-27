class AddFeaturedBooleanToKpccProgram < ActiveRecord::Migration
  def change
    add_column :programs_kpccprogram, :is_featured, :boolean, default: false, null: false
    KpccProgram.where(slug: ['take-two', 'offramp', 'airtalk']).update_all(is_featured: true)
  end
end
