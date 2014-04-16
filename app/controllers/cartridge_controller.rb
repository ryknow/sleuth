class CartridgeController < ApplicationController
  respond_to :json
  layout "navigation"

  def index
    render json: Cartridge.all.to_json
  end

  def show
    @cartridge = Cartridge.find params[:id]
  end

  def create
  end

  def search
    cartridge_pages = CartridgePage.joins(:page_tags).joins(:cartridge).where(page_tags: {name: params[:text]}).order("cartridges.name, page_num")
    @search_results = []

    @search_results = cartridge_pages.inject([]) do |memo, cp|
      memo << { cartridge: cp.cartridge.name, page: cp.page_num, tags: cp.page_tags.map(&:name) }
    end
  end

  def import
    uploaded_file = params[:datafile]
    File.open(Rails.root.join('public', 'uploads', params[:datafile].original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename)).readlines.each do |line|
      parsed_line = line.strip.split(",")
      if parsed_line.size == 3
        cp = CartridgePage.find_or_create_by page_num: parsed_line[1]
        c  = Cartridge.find_or_create_by name: parsed_line[0]
        parsed_line[2].split(";").each do |tag|
          pt = PageTag.find_or_create_by name: tag.strip
          cp.page_tags.push pt
        end
        cp.cartridge = c
        cp.save
        c.save
      end
    end

    render json: File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename)).readlines
  end
end
