class AddInfoToMuseum < ActiveRecord::Migration
  def self.up
    add_column :museums, :website, :string
    add_column :museums, :hours, :text
  end

  def self.down
    remove_column :museums, :hours
    remove_column :museums, :url
  end
end
