require File.dirname(__FILE__) + '/../init.rb'
require 'hpricot'
require 'action_controller'
require 'active_support'

# create some fake controllers
class ApplicationController < ActionController::Base
  def some_shitty_method
  end
end

class PirateController < ApplicationController
  def index
  end
  
  def yo_ho_ho
  end
  
  def and_a_bottle_o_rum
  end
end

describe Mapmaker, "generating sitemaps from config at the bottom of the spec" do
  before :all do
    RAILS_ROOT = File.dirname(__FILE__)
  end
  
  it "generate an index that points to the ninjas and from_controller sitemaps" do
    index = Mapmaker::Generator.create_sitemap_index
  end
  
  it "should generate a ninjas sitemap with 4 crappy duck name urls etc" do
    ninjas = Mapmaker::Generator.create_sitemap(:ninjas)
    urls = (Hpricot(ninjas)/'url'/'loc').collect(&:inner_text)
    duck_names = %w(heuy dewy louis)
    
    duck_names.each do |duck_name|
      urls.any? {|url| url.ends_with? duck_name}
    end
  end
  
  it "should generate a from_controller sitemap that derives all the urls from the public methods" do
    pirates = Mapmaker::Generator.create_sitemap(:from_controller)
    urls = (Hpricot(pirates)/'url'/'loc').collect(&:inner_text)
    pirate_methods = %w(index yo_ho_ho and_a_bottle_o_rum)
    
    pirate_methods.each do |pirate_method|
      urls.any? {|url| url.ends_with? pirate_method}
    end
  end
end