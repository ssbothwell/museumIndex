class CreateMuseums < ActiveRecord::Migration
  def self.up
    create_table :museums do |t|
      
      t.string :name
      t.string :location
      t.integer :telephone
      t.timestamps
    end
  end

  def self.down
    drop_table :museums
  end
end
