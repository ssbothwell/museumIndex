class ExhibitionsController < ResourceController::Base
  access_control do
    allow all, :to => [:index, :show, :current]     
    allow :admin
    allow logged_in
  end
  
  def show
    @current = Exhibition.current
    @exhibition = Exhibition.find(params[:id])
  end
  
end
