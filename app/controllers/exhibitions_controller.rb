class ExhibitionsController < ResourceController::Base
  access_control do
    allow all, :to => [:index, :show, :current]     
    allow :admin
    allow logged_in
  end
  
end
