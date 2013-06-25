class AddImageToKpccPrograms < ActiveRecord::Migration
  def change
    add_column :programs_kpccprogram, :image, :string
  end
end
