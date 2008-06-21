class MapmakerController < ApplicationController
  def index
    render :xml => Mapmaker::Generator.create_sitemap_index
  end
  
  def show
    render :xml => Mapmaker::Generator.create_sitemap(params[:url_name])
  end
end