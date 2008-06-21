require 'rails_generator/generators/components/controller/controller_generator'

class MapmakerControllerGenerator < ControllerGenerator
  def manifest
    record do |m|
      m.class_collisions class_path, "MapmakerController"
      
      m.directory File.join('app/controllers', class_path)
      
      
    end
  end
end