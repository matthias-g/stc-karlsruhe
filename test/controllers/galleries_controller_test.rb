require 'test_helper'

class GalleriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gallery = galleries(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get galleries_url
    assert_response :success
    assert_not_nil assigns(:galleries)
  end

  test "should get new" do
    sign_in users(:admin)
    get new_gallery_url
    assert_response :success
  end

  test "should create gallery" do
    sign_in users(:admin)
    assert_difference('Gallery.count') do
      post galleries_url, params: { gallery: { title: @gallery.title } }
    end

    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "should show gallery" do
    sign_in users(:admin)
    get gallery_url(@gallery)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_gallery_url(@gallery)
    assert_response :success
  end

  test "should update gallery" do
    sign_in users(:admin)
    patch gallery_url(@gallery), params: { gallery: { title: @gallery.title } }
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "non-admin should not update gallery" do
    sign_in users(:sabine)
    patch gallery_url(@gallery), params: { gallery: { title: @gallery.title } }
    assert_redirected_to root_path
    assert_not_nil flash[:error]
  end

  test "leader should update gallery" do
    @gallery = galleries(:four)
    project_day = @gallery.projects.first.days.first
    project_day.date = 1.day.ago
    project_day.save!
    sign_in users(:rolf)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_equal new_title, assigns(:gallery).title
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "update should not be possible for leader if project takes place in future" do
    @gallery = galleries(:four)
    project_day = @gallery.projects.first.days.first
    project_day.date = 1.day.from_now
    project_day.save!
    sign_in users(:rolf)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_not_equal new_title, assigns(:gallery).title
    assert_redirected_to root_path
  end

  test "update should be possible for admin even if project takes place in future" do
    @gallery = galleries(:four)
    project_day = @gallery.projects.first.days.first
    project_day.date = 1.day.from_now
    project_day.save!
    sign_in users(:admin)
    new_title = 'This is the new title'
    patch gallery_url(@gallery), params: { gallery: { title: new_title } }
    assert_equal new_title, assigns(:gallery).title
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  test "update gallery redirects to referer" do
    @gallery = galleries(:four)
    sign_in users(:rolf)
    referer = project_path(@gallery.projects.first)
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
