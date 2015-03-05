require 'test_helper'

class PageSectionsControllerTest < ActionController::TestCase
  setup do
    @page_section = page_sections(:one)
    sign_in users(:admin)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_section" do
    assert_difference('PageSection.count') do
      post :create, page_section: { title: @page_section.title, index: 0 }
    end

    assert_redirected_to page_section_path(assigns(:page_section))
  end

  test "should show page_section" do
    get :show, id: @page_section
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_section
    assert_response :success
  end

  test "should update page_section" do
    patch :update, id: @page_section, page_section: { title: @page_section.title, index: 0 }
    assert_redirected_to page_section_path(assigns(:page_section))
  end

  test "should destroy page_section" do
    assert_difference('PageSection.count', -1) do
      delete :destroy, id: @page_section
    end

    assert_redirected_to page_sections_path
  end
end
