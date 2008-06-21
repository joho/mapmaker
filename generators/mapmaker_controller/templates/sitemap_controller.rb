class MapmakerController < ApplicationController
  
  def index
    render :xml => Sitemaps::Generator.create_sitemap_index
  end
  
  def show
    render :xml => Sitemaps::Generator.create_sitemap(params[:url_name])
  end
end