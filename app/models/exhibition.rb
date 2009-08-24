class Exhibition < ActiveRecord::Base
  validates_uniqueness_of :title
  belongs_to :museum
end
