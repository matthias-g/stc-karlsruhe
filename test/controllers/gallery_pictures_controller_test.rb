require 'test_helper'

class GalleryPicturesControllerTest < ActionController::TestCase
  setup do
    @gallery_picture = gallery_pictures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gallery_pictures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gallery_picture" do
    assert_difference('GalleryPicture.count') do
      post :create, gallery_picture: { gallery_id: @gallery_picture.gallery_id, picture: @gallery_picture.picture }
    end

    assert_redirected_to gallery_picture_path(assigns(:gallery_picture))
  end

  test "should show gallery_picture" do
    get :show, id: @gallery_picture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gallery_picture
    assert_response :success
  end

  test "should update gallery_picture" do
    patch :update, id: @gallery_picture, gallery_picture: { gallery_id: @gallery_picture.gallery_id, picture: @gallery_picture.picture }
    assert_redirected_to gallery_picture_path(assigns(:gallery_picture))
  end

  test "should destroy gallery_picture" do
    assert_difference('GalleryPicture.count', -1) do
      delete :destroy, id: @gallery_picture
    end

    assert_redirected_to gallery_pictures_path
  end
end
