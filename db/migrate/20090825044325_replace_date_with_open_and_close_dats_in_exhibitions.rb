class ReplaceDateWithOpenAndCloseDatsInExhibitions < ActiveRecord::Migration
  def self.up
    remove_column :exhibitions, :date
    add_column :exhibitions, :date_open, :string
    add_column :exhibitions, :date_close, :string
  end

  def self.down
    add_column :exhibitions, :date
    remove_column :exhibitions, :date_open, :string
    remove_column :exhibitions, :date_close, :string
  end
end
