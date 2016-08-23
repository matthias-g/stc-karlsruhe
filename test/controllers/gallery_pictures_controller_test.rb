require 'test_helper'

class GalleryPicturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
    @gallery_picture = gallery_pictures(:one)
  end

  test "should get index" do
    get gallery_pictures_url
    assert_response :success
    assert_not_nil assigns(:gallery_pictures)
  end

  test "should get new" do
    get new_gallery_url
    assert_response :success
  end

  test "should create gallery_picture" do
    assert_difference('GalleryPicture.count') do
      post gallery_pictures_url, params: { gallery_picture: { gallery_id: @gallery_picture.gallery_id, picture: @gallery_picture.picture } }
    end

    assert_redirected_to gallery_picture_path(assigns(:gallery_picture))
  end

  test "should show gallery_picture" do
    get gallery_picture_url(@gallery_picture)
    assert_response :success
  end

  test "should get edit" do
    get edit_gallery_picture_url(@gallery_picture)
    assert_response :success
  end

  test "should update gallery_picture" do
    patch gallery_picture_url(@gallery_picture), params: { gallery_picture: { gallery_id: @gallery_picture.gallery_id, picture: @gallery_picture.picture } }
    assert_redirected_to gallery_path(@gallery_picture.gallery)
  end

  test "should destroy gallery_picture with redirection to gallery" do
    assert_difference('GalleryPicture.count', -1) do
      delete gallery_picture_url(@gallery_picture)
    end
    assert_redirected_to gallery_path(@gallery_picture.gallery)
  end

  test "should destroy gallery_picture with redirection to referer" do
    referer = 'https://servethecity-karlsruhe.de/projects/some-project'
    assert_difference('GalleryPicture.count', -1) do
      delete gallery_picture_url(@gallery_picture), headers: { 'HTTP_REFERER': referer }
    end
    assert_redirected_to referer
  end
end
