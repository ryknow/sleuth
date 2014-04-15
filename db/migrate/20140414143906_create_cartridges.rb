class CreateCartridges < ActiveRecord::Migration
  def change
    create_table :cartridges do |t|
      t.string :name
      t.timestamps
    end

    create_table :cartridge_pages do |t|
      t.belongs_to :cartridge
      t.timestamps
    end

    create_table :page_tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :cartridge_pages_page_tags do |t|
      t.belongs_to :cartridge_page
      t.belongs_to :page_tag
      t.timestamps
    end
  end
end
