class CartridgePage < ActiveRecord::Base
  belongs_to :cartridge
  has_and_belongs_to_many :page_tags
end
