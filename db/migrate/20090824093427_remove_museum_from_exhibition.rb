class RemoveMuseumFromExhibition < ActiveRecord::Migration
  def self.up
    remove_column :exhibitions, :museum
  end

  def self.down
    add_column :exhibitions, :museum, :string
  end
end
