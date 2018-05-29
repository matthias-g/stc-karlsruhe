require 'test_helper'

class GalleriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gallery = galleries(:default)
  end

  test "gallery index" do
    sign_in users(:admin)
    get galleries_url
    assert_response :success
    assert_select '#galleries.index tbody tr', Gallery.all.count
  end

  test "gallery new" do
    sign_in users(:admin)
    get new_gallery_url
    assert_response :success
  end

  test "gallery create" do
    sign_in users(:admin)
    assert_difference('Gallery.count') do
      post galleries_url, params: { gallery: { title: 'NewGallery' } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select '#galleries.show h1', 'NewGallery'
  end

  test "gallery show" do
    sign_in users(:unrelated)
    get gallery_url(@gallery)
    assert_response :success
    assert_select '#galleries.show h1', @gallery.title
  end

  test "gallery edit" do
    sign_in users(:admin)
    get edit_gallery_url(@gallery)
    assert_response :success
    assert_select '#galleries.edit h1', @gallery.title
  end

  test "admin and volunteer and leader can update gallery" do
    %w[admin volunteer leader].each do |username|
      sign_in users(username)
      patch gallery_url(@gallery), params: { gallery: { title: "UpdatedGallery#{username}" } }
      assert_redirected_to @gallery
      follow_redirect!
      assert_response :success
      assert_select '#galleries.show h1', "UpdatedGallery#{username}"
    end
  end

  test "non-volunteer cannot update gallery" do
    sign_in users(:unrelated)
    patch gallery_url(@gallery), params: { gallery: { title: 'UpdatedGallery' } }
    assert_not_nil flash[:error]
    assert_redirected_to root_path
  end

  test "can update today or past action gallery" do
    events(:default).update_attribute :date, 1.day.ago
    sign_in users(:leader)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_response :redirect
    assert_equal new_title, @gallery.reload.title
  end

  test "leader cannot update future action gallery" do
    events(:default).update_attribute :date, 1.day.from_now
    sign_in users(:leader)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_not_equal new_title, @gallery.reload.title
    assert_response :redirect
  end

  test "admin can update future action gallery" do
    events(:default).update_attribute :date, 1.day.from_now
    sign_in users(:admin)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_response :redirect
    assert_equal new_title, @gallery.reload.title
  end

  test "gallery update redirects to referer" do
    sign_in users(:leader)
    referer = action_path(@gallery.actions.first)
    patch gallery_url(@gallery), params: { gallery: { title: @gallery.title } }, headers: { 'HTTP_REFERER': referer}
    assert_redirected_to referer
  end

  test "should destroy gallery" do
    sign_in users(:admin)
    assert_difference('Gallery.count', -1) do
      delete gallery_url(@gallery)
    end
    assert_redirected_to galleries_path
  end

end
