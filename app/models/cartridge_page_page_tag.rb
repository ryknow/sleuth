class CartridgePagePageTag < ActiveRecord::Base
  belongs_to :page_tag
  belongs_to :cartridge_page
end
