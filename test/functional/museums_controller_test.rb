require 'test_helper'

class MuseumsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Museum.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Museum.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Museum.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to museum_url(assigns(:museum))
  end
  
  def test_edit
    get :edit, :id => Museum.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Museum.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Museum.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Museum.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Museum.first
    assert_redirected_to museum_url(assigns(:museum))
  end
  
  def test_destroy
    museum = Museum.first
    delete :destroy, :id => museum
    assert_redirected_to museums_url
    assert !Museum.exists?(museum.id)
  end
end
