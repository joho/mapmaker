require File.dirname(__FILE__) + '/../init.rb'
require 'hpricot'

class PirateController
  def index
  end
  
  def yo_ho_ho
  end
  
  def and_a_bottle_o_rum
  end
end

describe Mapmaker, "generating sitemaps from config at the bottom of the spec" do
  before :each do
    Mapmaker::ConfigurationManager.config(File.dirname(__FILE__) + '/config/sitemap.rb')
  end
  
  it "generate an index that points to the ninjas and from_controller sitemaps" do
    index = Mapmaker::Generator.create_sitemap_index
  end
  
  it "should generate a ninjas sitemap with 4 crappy duck name urls etc" do
    ninjas = Mapmaker::Generator.create_sitemap(:ninjas)
    ninjas.should_not == nil
  end
  
  it "should generate a from_controller sitemap that derives all the urls from the public methods" do
    pirates = Mapmaker::Generator.create_sitemap(:from_controller)
    pirates.should_not == nil 
  end
end