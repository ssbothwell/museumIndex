class AddMuseumkeyToExhibition < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :museum_id, :integer
  end

  def self.down
    remove_column :exhibitions, :museum_id
  end
end
