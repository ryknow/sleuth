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
    cartridge_pages = CartridgePage.joins(:page_tags).where(page_tags: {name: params[:text]})
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

    render json: File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename)).readlines
  end
end
