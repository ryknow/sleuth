class CartridgeController < ApplicationController
  require "#{Rails.root}/lib/uploader"
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
    uploader = Sleuth::Uploader.new(params[:datafile])
    uploader.write.save

    redirect_to action: "index"
  end
end
