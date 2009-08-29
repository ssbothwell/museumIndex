class Museum < ActiveRecord::Base
  has_many :exhibitions
  has_attached_file :photo, :styles => { :small => "300x300>" },
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']  

  def to_param
    "#{id}-#{name.gsub(/[^a-z1-9]+/i, '_')}"
  end
  
end
