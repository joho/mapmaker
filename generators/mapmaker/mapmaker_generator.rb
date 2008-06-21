class MapmakerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'controllers'

      m.template 'mapmaker_controller.rb', 'app/controllers/mapmaker_controller.rb'
      m.template 'sitemap.rb', 'config/sitemap.rb'
    end
  end
  
protected
  def banner
    %(Usage: #{$0} mapmaker_controller
    Add the following lines to your routes.rb
      map.connect 'sitemap.xml', :controller => 'mapmaker', :action => 'index'
      map.connect 'sitemaps/:url_name.xml', :controller => 'mapmaker', :action => 'show', :url_name => url_name)
  end
end