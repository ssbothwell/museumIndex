require 'test_helper'

class ExhibitionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Exhibition.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Exhibition.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Exhibition.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to exhibition_url(assigns(:exhibition))
  end
  
  def test_edit
    get :edit, :id => Exhibition.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Exhibition.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Exhibition.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Exhibition.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Exhibition.first
    assert_redirected_to exhibition_url(assigns(:exhibition))
  end
  
  def test_destroy
    exhibition = Exhibition.first
    delete :destroy, :id => exhibition
    assert_redirected_to exhibitions_url
    assert !Exhibition.exists?(exhibition.id)
  end
end
