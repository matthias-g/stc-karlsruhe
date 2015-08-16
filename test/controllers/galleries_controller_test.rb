require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  setup do
    @gallery = galleries(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:galleries)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create gallery" do
    sign_in users(:admin)
    assert_difference('Gallery.count') do
      post :create, gallery: { title: @gallery.title }
    end

    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "should show gallery" do
    sign_in users(:admin)
    get :show, id: @gallery
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @gallery
    assert_response :success
  end

  test "should update gallery" do
    sign_in users(:admin)
    patch :update, id: @gallery, gallery: { title: @gallery.title }
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "non-admin should not update gallery" do
    sign_in users(:sabine)
    patch :update, id: @gallery, gallery: { title: @gallery.title }
    assert_redirected_to root_path
    assert_not_nil flash[:error]
  end

  test "leader should update gallery" do
    @gallery = galleries(:three)
    sign_in users(:rolf)
    patch :update, id: @gallery, gallery: { title: @gallery.title }
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "should destroy gallery" do
    sign_in users(:admin)
    assert_difference('Gallery.count', -1) do
      delete :destroy, id: @gallery
    end

    assert_redirected_to galleries_path
  end
end
