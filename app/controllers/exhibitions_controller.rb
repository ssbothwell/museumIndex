class ExhibitionsController < ResourceController::Base
  access_control do
    allow all, :to => [:index, :show]     
    allow :admin
    allow logged_in
  end

end
