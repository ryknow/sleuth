class AddPageNumToCartridgePages < ActiveRecord::Migration
  def change
    add_column :cartridge_pages, :page_num, :integer
  end
end
