class AddCoordinatesToMuseum < ActiveRecord::Migration
  def self.up
    add_column :museums, :latitude, :float
    add_column :museums, :longitude, :float
  end

  def self.down
    remove_column :museums, :latitude
    remove_column :museums, :longitude
  end
end
