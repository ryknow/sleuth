class PageTag < ActiveRecord::Base
  has_and_belongs_to_many :cartridge_pages
end
