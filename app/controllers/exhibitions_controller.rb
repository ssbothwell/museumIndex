class ExhibitionsController < ResourceController::Base
  access_control do
    allow :admin  
    actions :index, :show do
    allow all
    end
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
