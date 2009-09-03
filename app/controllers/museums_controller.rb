class MuseumsController < ResourceController::Base
  access_control do
    allow all, :to => [:index, :show]     
    allow :admin
  end
  
  def show
    @museum = Museum.find(params[:id]) 
    geo = Google::Geo.new @GOOGLEAPI
    addresses = geo.locate @museum.location
    @address = addresses.first
  end

end