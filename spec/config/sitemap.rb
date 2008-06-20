sitemap 'http://whoisjohnbarton.com' do
  url_set :ninjas do |set|
    %w(heuy dewy louis).each do |duck_name|
      set.page "/ninja_ducks/#{duck_name}", :updated_at => Time.now.at_midnight, :priority => 0.3, :change_frequency => :monthly
    end
  end
  
  url_set :from_controller do |set|
    set.reflect_off_controller PirateController, "/pirate_monkeys/%s", :change_frequency => :always, :priority => 0.8
  end
end