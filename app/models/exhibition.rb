class Exhibition < ActiveRecord::Base
  validates_uniqueness_of :title
  belongs_to :museum
  

  
  named_scope :current, lambda { {:conditions => ["date_open IS NULL OR date_open <= ?", 0.day.ago]} }
  named_scope :upcoming, lambda { {:conditions => ["date_open > ?", 0.day.ago]} } 
  named_scope :past, lambda { {:conditions => ["date_close < ?", 0.day.ago]} }
end
