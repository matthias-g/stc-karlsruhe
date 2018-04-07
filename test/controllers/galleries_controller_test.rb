require 'test_helper'

class GalleriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gallery = galleries(:one)
  end

  test 'gallery index' do
    sign_in users(:admin)
    get galleries_url
    assert_response :success
    assert_select '#galleries.index tbody tr', 8
  end

  test 'gallery new' do
    sign_in users(:admin)
    get new_gallery_url
    assert_response :success
  end

  test 'gallery create' do
    sign_in users(:admin)
    assert_difference('Gallery.count') do
      post galleries_url, params: { gallery: { title: 'NewGallery' } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select '#galleries.show h1', 'NewGallery'
  end

  test 'gallery show' do
    sign_in users(:birgit) # generic user
    get gallery_url(@gallery)
    assert_response :success
    assert_select '#galleries.show h1', @gallery.title
  end

  test 'gallery edit' do
    sign_in users(:admin)
    get edit_gallery_url(@gallery)
    assert_response :success
    assert_select '#galleries.edit h1', @gallery.title
  end

  test 'admin and volunteer and leader can update gallery' do
    %w[admin sabine rolf].each do |username|
      sign_in users(username)
      patch gallery_url(@gallery), params: { gallery: { title: "UpdatedGallery#{username}" } }
      assert_redirected_to @gallery
      follow_redirect!
      assert_response :success
      assert_select '#galleries.show h1', "UpdatedGallery#{username}"
    end
  end

  test 'non-volunteer cannot update gallery' do
    sign_in users(:birgit)
    patch gallery_url(@gallery), params: { gallery: { title: 'UpdatedGallery' } }
    assert_not_nil flash[:error]
    assert_redirected_to root_path
  end

  test 'can update today or past action gallery' do
    @gallery = galleries(:four)
    event = @gallery.actions.first.events.first
    event.date = 1.day.ago
    event.save!
    sign_in users(:rolf) # leader
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_response :redirect
    assert_equal new_title, @gallery.reload.title
  end

  test 'leader cannot update future action gallery' do
    @gallery = galleries(:four)
    event = @gallery.actions.first.events.first
    event.date = 1.day.from_now
    event.save!
    sign_in users(:rolf)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_not_equal new_title, @gallery.reload.title
    assert_response :redirect
  end

  test 'admin can update future action gallery' do
    @gallery = galleries(:four)
    event = @gallery.actions.first.events.first
    event.date = 1.day.from_now
    event.save!
    sign_in users(:admin)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_response :redirect
    assert_equal new_title, @gallery.reload.title
  end

  test 'gallery update redirects to referer' do
    @gallery = galleries(:four)
    sign_in users(:rolf)
    referer = action_path(@gallery.actions.first)
    patch gallery_url(@gallery), params: { gallery: { title: @gallery.title } }, headers: { 'HTTP_REFERER': referer}
    assert_redirected_to referer
  end

  test 'should destroy gallery' do
    sign_in users(:admin)
    assert_difference('Gallery.count', -1) do
      delete gallery_url(@gallery)
    end
    assert_redirected_to galleries_path
  end

end
