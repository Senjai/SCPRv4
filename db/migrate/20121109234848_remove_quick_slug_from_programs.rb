class RemoveQuickSlugFromPrograms < ActiveRecord::Migration
  def change
    remove_column :programs_kpccprogram, :quick_slug
  end
end
