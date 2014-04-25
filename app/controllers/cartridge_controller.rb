class CartridgeController < ApplicationController
  respond_to :json
  layout "navigation"

  def index
    @cartridges = Cartridge.all
  end

  def show
    @cartridge = Cartridge.find params[:id]
  end

  def create
  end

  def search
    cartridge_pages = CartridgePage.joins(:page_tags).joins(:cartridge).
      where(page_tags: {name: params[:text]}).order("cartridges.name, page_num")

    @search_results = cartridge_pages.inject({}) do |memo, cp|
      memo[cp.cartridge.name] ||= []
      unless memo[cp.cartridge.name].include?({ page: cp.page_num, tags: cp.page_tags.map(&:name) })
        memo[cp.cartridge.name].push({ page: cp.page_num, tags: cp.page_tags.map(&:name) })
      end
      memo
    end
    @search_results
  end

  def import
    uploaded_file = params[:datafile]

    File.open(Rails.root.join('public', 'uploads', params[:datafile].original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename)).readlines.each do |line|
      begin
        parsed_line = line.strip.split(",")
        if parsed_line.size == 3
          c  = Cartridge.find_or_create_by name: parsed_line[0]
          cp = CartridgePage.find_or_create_by_page_num_and_cartridge_id(parsed_line[1], c.id)

          parsed_line[2].split(";").each do |tag|
            pt = PageTag.find_or_create_by name: tag.strip
            cp.page_tags.push pt
          end
          cp.cartridge = c
          cp.save
          c.save
        end
      rescue
        Rails.logger.error "Error parsing line #{line}"
      end
    end
    render json: File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename)).readlines
  end
end
