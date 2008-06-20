require File.dirname(__FILE__) + '/../init.rb'

class PirateController
  def index
  end
  
  def yo_ho_ho
  end
  
  def and_a_bottle_o_rum
  end
end

describe Mapmaker, "generating sitemaps from config at the bottom of the spec" do
  it "generate an index that points to the ninjas and from_controller sitemaps"
  it "should generate a ninjas sitemap with 4 crappy duck name urls etc"
  it "should generate a from_controller sitemap that derives all the urls from the public methods"
end

__END__
sitemap 'http://whoisjohnbarton.com' do
  urlset :ninjas do |set|
    %w(heuy dewy louis).each do |duck_name|
      set.page '/ninja_ducks/#{duck_name}', :updated_at => Time.now.at_midnight, :priority => 0.3, :change_frequency => :monthly
    end
  end
  
  urlset :from_controller do |set|
    set.reflect_off_controller PirateController, "/pirate_monkeys/%s", :change_frequency => :always, :priority => 0.8
  end
end