class Museum < ActiveRecord::Base
  has_many :exhibitions
  
  def to_param
    "#{id}-#{name.gsub(/[^a-z1-9]+/i, '-')}"
  end
  
end
