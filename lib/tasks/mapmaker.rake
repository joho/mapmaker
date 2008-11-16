desc 'generate your sitemaps into your public folder'
task :generate_sitemaps => :environment do
  sitemap_key = ENV['SITEMAP'].to_sym || Mapmaker::ConfigurationManager::DEFAULT_KEY
  
  File.open("#{RAILS_ROOT}/public/sitemap.xml", "w") do |f|
    f.write(Mapmaker::Generator.create_sitemap_index(sitemap_key))
  end
  
  config = Mapmaker::ConfigurationManager.config[sitemap_key]
  if config.keys.size > 1
    sitemaps_dir = "#{RAILS_ROOT}/public/sitemaps"
    FileUtils.mkdir(sitemaps_dir) unless File.exists?(sitemaps_dir)
    Mapmaker::ConfigurationManager.config[sitemap_key].keys.each do |url_set_key|
      File.open("#{sitemaps_dir}/#{url_set_key}.xml", "w") do |f|
        f.write(Mapmaker::Generator.create_sitemap(sitemap_key, url_set_key))
      end
    end
  end
end