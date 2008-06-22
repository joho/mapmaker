module Mapmaker
  class Page
    attr_accessor :url, :updated_at, :priority, :change_frequency
    
    def initialize(new_url, options = {})
      self.url = new_url
      options.each {|attr_name, value| self.send "#{attr_name}=", value }
    end
  end
  
  class UrlSet
    def initialize(hostname, proc)
      @hostname = hostname
      @page_store = []
      create_load_pages_method proc
    end
    
    def page(url, options = {})
      @page_store << Page.new(@hostname + url, options)
    end
    
    def reflect_off_controller(controller_class, url_format_string, options = {})
      controller_actions = controller_class.public_instance_methods - 
                           controller_class.hidden_actions - 
                           ApplicationController.public_instance_methods
      
      
      options[:mixins_to_exclude] and options[:mixins_to_exclude].each do |mixins|
        controller_actions -= mixins.public_instance_methods
      end
      
      controller_actions.each do |method_name|
        page url_format_string % method_name, options.except(:mixins_to_exclude)
      end
    end
    
    def pages
      send :load_pages if @page_store.empty?
      @page_store
    end
  private
    def create_load_pages_method(block)
      klass = class << self; self; end
      klass.instance_eval do
        define_method :load_pages, block
      end
    end
  end
  
  class ConfigurationManager
    def self.config(file_name = nil)
      @@configuration if defined? @@configuration and @@configuration 
      
      file_name ||= RAILS_ROOT + '/config/sitemap.rb'
      config_code = read_config_file(file_name)
      
      @@configuration = Configuration.new
      @@configuration.send :instance_eval, config_code
      @@configuration
    end
    
  private    
    def self.read_config_file(file_name)
      File.open(file_name) { |f| f.read }
    end 
  end
  
  class Configuration
    attr_reader :hostname

    def initialize
      @urlsets = {}
    end
    
    def [](key)
      @urlsets[key].pages
    end
    
    def keys
      @urlsets.keys
    end
    
    def only_one_url_set?
      @urlsets.size == 1
    end
    
  private
    def sitemap(hostname)
      @hostname = hostname
      yield
    end
    
    def url_set(name, &block)
      @urlsets[name] = UrlSet.new(@hostname, block)
    end
  end # end config
end