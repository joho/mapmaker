require 'rubygems'
require 'hpricot'
require 'action_controller'
require 'active_support'
require 'rake'
Dir.glob(File.dirname(__FILE__) + '/../lib/*.rb').each {|rb| require rb}
require File.dirname(__FILE__) + '/../example/controllers'

module MapmakerSpecHelper
  def check_all_urls_exist(xml, urls)
    xml_urls = (Hpricot(xml)/'url'/'loc').collect(&:inner_text)
  
    urls.each do |url_string|
      xml_urls.any?{|url| url.ends_with? url_string}.should == true
    end
  end
end

describe Mapmaker, "generating sitemaps from example config" do
  include MapmakerSpecHelper
  
  before :all do
    RAILS_ROOT = File.dirname(__FILE__) + '/../example' unless defined? RAILS_ROOT
  end
  
  describe "in the main sitemap" do
    it "should generate an index for pirates and from_controller" do
      index = Mapmaker::Generator.create_sitemap_index(:main)
      index.should =~ /ninjas.xml/
      index.should =~ /from_controller.xml/
    end
  
    it "should generate a ninjas sitemap with 4 crappy duck name urls etc" do
      ninjas = Mapmaker::Generator.create_sitemap(:main, :ninjas)
      check_all_urls_exist(ninjas, %w(heuy dewy louis))
    end
    
    it "should generate a from_controller sitemap that derives all the urls from the public methods" do
      pirates = Mapmaker::Generator.create_sitemap(:main, :from_controller)
      check_all_urls_exist(pirates, %w(index yo_ho_ho and_a_bottle_o_rum))
    end
  end
  
  describe "in the default sitemap" do
    it "should generate an index with all the urls in it" do
      index = Mapmaker::Generator.create_sitemap_index
      check_all_urls_exist(index, %(donatello leonardo raphael michaelangelo))
    end
  end
  
  describe 'rake task' do
    before :all do
      task :environment do
        # this is a dummy task that doesn't do anything
      end
  
      load('lib/tasks/mapmaker.rake')
      
      @task = Rake::Task['generate_sitemaps']
    end
    
    before :each do
      %x[ rm -f #{RAILS_ROOT}/public/* ]
    end

    it "should exist" do
      @task.should_not == nil
    end
    
    it "should store the index at public/sitemap.xml" do
      File.exists?("#{RAILS_ROOT}/public/sitemap.xml").should == false
      
      @task.invoke
      
      File.exists?("#{RAILS_ROOT}/public/sitemap.xml").should == true
    end
  end
end