require 'test_helper'

class NewsEntriesControllerTest < ActionController::TestCase
  setup do
    @news_entry = news_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news_entries)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create news_entry" do
    sign_in users(:admin)
    assert_difference('NewsEntry.count') do
      post :create, news_entry: { picture: @news_entry.picture, teaser: @news_entry.teaser,
                                  text: @news_entry.text, title: @news_entry.title,
                                  category: @news_entry.category, visible: @news_entry.visible }
    end

    assert_redirected_to news_entry_path(assigns(:news_entry))
  end

  test "should show news_entry" do
    sign_in users(:admin)
    get :show, id: @news_entry
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @news_entry
    assert_response :success
  end

  test "should update news_entry" do
    sign_in users(:admin)
    patch :update, id: @news_entry, news_entry: { picture: @news_entry.picture, teaser: @news_entry.teaser,
                                                  text: @news_entry.text, title: @news_entry.title,
                                                  category: @news_entry.category, visible: @news_entry.visible }
    assert_redirected_to news_entry_path(assigns(:news_entry))
  end

  test "should destroy news_entry" do
    sign_in users(:admin)
    assert_difference('NewsEntry.count', -1) do
      delete :destroy, id: @news_entry
    end
    assert_redirected_to news_entries_path
  end
end
