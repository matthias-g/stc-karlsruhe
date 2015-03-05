require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    @page = pages(:one)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create page" do
    sign_in users(:admin)
    assert_difference('Page.count') do
      post :create, page: { title: 'New Page', header_name: 'bigheader' }
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should show page" do
    get :show, id: @page
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @page
    assert_response :success
  end

  test "should update page" do
    sign_in users(:admin)
    patch :update, id: @page, page: { title: @page.title }
    assert_redirected_to page_path(assigns(:page))
  end

  test "should destroy page" do
    sign_in users(:admin)
    assert_difference('Page.count', -1) do
      delete :destroy, id: @page
    end

    assert_redirected_to pages_path
  end
end
