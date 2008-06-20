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
      @proc = proc
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
      @proc.call(self) if @page_store.empty?
      @page_store
    end
  end
  
  class ConfigurationManager
    @@configurations = {}
    
    def self.config(file_name = RAILS_ROOT + '/config/sitemap.rb')
      @@configurations unless @@configurations.empty?
      
      config_code = read_config_file(file_name)
      
      instance_eval config_code
    end
    
  private
    def self.sitemap(key, hostname, &block)
      @@configurations[key] = Configuration.new(hostname, block)
    end
    
    def self.read_config_file(file_name)
      config_code = nil
      File.open(file_name) do |f|
        config_code = f.read
      end
      config_code
    end 
  end
  
  class Configuration
    attr_reader :hostname

    def initialize(hostname, &block)
      @hostname = hostname
      @urlsets = {}
      block.call
    end
    
    def [](key)
      @urlsets[key] ? @urlsets[key].pages : []
    end
    
    def keys
      @urlsets.keys
    end
    
  private
    def url_set(name, &block)
      @urlsets[name] = UrlSet.new(@hostname, block)
    end
  end # end config
end