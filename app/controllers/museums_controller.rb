class MuseumsController < ResourceController::Base
  access_control do
    allow all, :to => [:index, :show]     
    allow :admin
  end

end