class Exhibition < ActiveRecord::Base
  validates_uniqueness_of :title
  belongs_to :museum
  
  def to_param
    "#{id}-#{title.gsub(/[^a-z1-9]+/i, '-')}"
  end
end
