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