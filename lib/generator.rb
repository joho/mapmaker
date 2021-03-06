require 'builder'

module Mapmaker
  class Generator
    def self.create_sitemap_index(sitemap_key = nil)
      sitemap_key ||= ConfigurationManager::DEFAULT_KEY
      config = ConfigurationManager.config[sitemap_key]

      # if there is only one url set create the sitemap for that
      return create_sitemap(config.keys[0]) if config.only_one_url_set?
      
      hostname = config.hostname

      xml = Builder::XmlMarkup.new :indent => 2
      xml.instruct!

      xml.sitemapindex('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                       'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
                       :url => 'http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd',
                       :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        config.keys.each do |sitemap|
          xml.sitemap do
            xml.loc "#{hostname}/sitemaps/#{sitemap}.xml"
          end
        end
      end
      xml.target!
    end

    def self.create_sitemap(*args)
      site_key = args.size > 1 ? args.shift : ConfigurationManager::DEFAULT_KEY
      url_name = args.shift.to_sym
      
      pages = ConfigurationManager.config[site_key][url_name]
      
      raise "Exceeded 50,000 URL limit in sitemap '#{url_name}.xml' (returned #{pages.size})" if pages.size > 50_000
      
      xml = Builder::XmlMarkup.new :indent => 2
      xml.instruct!
      xml.urlset('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                 'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
                 :url => 'http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd',
                 :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        pages.each do |page|
          xml.url do
            xml.loc page.url

            # optional fields
            xml.lastmod page.updated_at.w3c if page.updated_at
            xml.priority page.priority if page.priority
            xml.changefreq page.change_frequency.to_s if page.change_frequency
          end
        end
      end
    end
  end # end generator

end # end sitemaps 

