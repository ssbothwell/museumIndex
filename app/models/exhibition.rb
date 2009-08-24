class Exhibition < ActiveRecord::Base
  validates_uniqueness_of :title
  
end
