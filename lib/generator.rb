module Mapmaker
  class Generator
    def self.create_sitemap_index(key)
      sitemap_keys = Mapmaker::Configuration.instance.keys
      hostname = Mapmaker::Configuration.instance.hostname

      xml = Builder::XmlMarkup.new :indent => 2
      xml.instruct!

      xml.sitemapindex('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                       'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
                       :url => 'http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd',
                       :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        sitemap_keys.each do |sitemap|
          xml.sitemap do
            xml.loc "#{hostname}/sitemaps/#{sitemap}.xml"
          end
        end
      end
      xml.target!
    end

    def self.create_sitemap(url_name)
      pages = Mapmaker::Configuration.instance[url_name.to_sym]
      
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

