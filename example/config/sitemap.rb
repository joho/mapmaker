sitemap :main, 'http://whoisjohnbarton.com' do
  url_set :ninjas do
    %w(heuy dewy louis).each do |duck_name|
      page "/ninja_ducks/#{duck_name}", :updated_at => Time.now.at_midnight, :priority => 0.3, :change_frequency => :monthly
    end
  end
  
  url_set :from_controller do
    reflect_off_controller PirateController, "/pirate_monkeys/%s", :change_frequency => :always, :priority => 0.8
  end
end

sitemap 'http://alltimetop5.com' do
  url_set :ninjas do
    %(donatello leonardo raphael michaelangelo).each do |turtle_name|
      page "/ninja_turtles/#{turtle_name}", :updated_at => Time.now.at_midnight, :priority => 0.5, :change_frequency => :monthly
    end
  end
end