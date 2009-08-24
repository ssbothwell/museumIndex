class ExhibitionsController < ApplicationController
  def index
    @exhibitions = Exhibition.all
  end
  
  def show
    @exhibition = Exhibition.find(params[:id])
  end
  
  def new
    @exhibition = Exhibition.new
  end
  
  def create
    @exhibition = Exhibition.new(params[:exhibition])
    if @exhibition.save
      flash[:notice] = "Successfully created exhibition."
      redirect_to @exhibition
    else
      render :action => 'new'
    end
  end
  
  def edit
    @exhibition = Exhibition.find(params[:id])
  end
  
  def update
    @exhibition = Exhibition.find(params[:id])
    if @exhibition.update_attributes(params[:exhibition])
      flash[:notice] = "Successfully updated exhibition."
      redirect_to @exhibition
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @exhibition = Exhibition.find(params[:id])
    @exhibition.destroy
    flash[:notice] = "Successfully destroyed exhibition."
    redirect_to exhibitions_url
  end
end
