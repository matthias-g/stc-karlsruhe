require 'test_helper'

class PageSectionsControllerTest < ActionController::TestCase
  setup do
    @page_section = page_sections(:one)
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_not_nil assigns(:page_sections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_section" do
    assert_difference('PageSection.count') do
      post :create, page_section: { message: @page_section.message, title: @page_section.title }
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
    patch :update, id: @page_section, page_section: { message: @page_section.message, title: @page_section.title }
    assert_redirected_to page_section_path(assigns(:page_section))
  end

  test "should destroy page_section" do
    assert_difference('PageSection.count', -1) do
      delete :destroy, id: @page_section
    end

    assert_redirected_to page_sections_path
  end
end