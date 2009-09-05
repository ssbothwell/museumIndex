class ExhibitionsController < ResourceController::Base
  access_control do
    allow :admin  
    allow all, :to => [:index, :show]
  end
  
  def show
    @current = Exhibition.current
    @exhibition = Exhibition.find(params[:id])
  end
  
  def index
    @search = Exhibition.search(params[:search])
    @exhibitions = @search.all
  end
  
end
