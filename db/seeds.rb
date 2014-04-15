# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cartridges = [
  {name: "Cartridge 1"}, 
  {name: "Cartridge 2"}, 
  {name: "Cartridge 3"}, 
  {name: "Cartridge 4"} 
]

cartridge_pages = [
  {cartridge_id: 1, page_num: 5},
  {cartridge_id: 1, page_num: 9},
  {cartridge_id: 1, page_num: 6},
  {cartridge_id: 2, page_num: 28},
  {cartridge_id: 3, page_num: 15},
  {cartridge_id: 3, page_num: 3},
  {cartridge_id: 4, page_num: 8}
]

page_tags = [
  {name: "easter"},
  {name: "birthday"},
  {name: "flower"},
  {name: "dog"},
  {name: "baby"}
]
  
cartridges.each do |c|
  Cartridge.create(name: c[:name]).save
end

cps = cartridge_pages.map do |cp|
  page = CartridgePage.create(cartridge_id: cp[:cartridge_id], page_num: cp[:page_num])
  page.save
  page
end

page_tags.each do |pt|
  PageTag.create(name: pt[:name]).cartridge_pages.push cps[Random.rand(7)]
end
