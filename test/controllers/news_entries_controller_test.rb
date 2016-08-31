require 'test_helper'

class NewsEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @news_entry = news_entries(:one)
  end

  test "should get index" do
    get news_entries_url
    assert_response :success
    assert_select '.news-teaser', 2
  end

  test "should show teaser in index if available" do
    get news_entries_url
    assert_select '.news-teaser div p', news_entries(:one).teaser
  end

  test "should show text in index if no teaser available" do
    get news_entries_url
    assert_select '.news-teaser div p', news_entries(:two).text
  end

  test "should get new" do
    sign_in users(:admin)
    get new_news_entry_url
    assert_response :success
  end

  test "should create news_entry" do
    sign_in users(:admin)
    assert_difference('NewsEntry.count') do
      post news_entries_url, params: { news_entry: { picture: @news_entry.picture, teaser: @news_entry.teaser,
                                        text: @news_entry.text, title: @news_entry.title,
                                        category: @news_entry.category, visible: @news_entry.visible } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', @news_entry.title
  end

  test "should show news_entry" do
    sign_in users(:admin)
    get news_entry_url(@news_entry)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_news_entry_url(@news_entry)
    assert_response :success
  end

  test "should update news_entry" do
    sign_in users(:admin)
    patch news_entry_url(@news_entry), params: { news_entry: { picture: @news_entry.picture, teaser: @news_entry.teaser,
                                                  text: @news_entry.text, title: 'new title',
                                                  category: @news_entry.category, visible: @news_entry.visible } }
    assert_redirected_to news_entry_path(@news_entry.reload)
    assert_equal 'new title', @news_entry.title
  end

  test "should destroy news_entry" do
    sign_in users(:admin)
    assert_difference('NewsEntry.count', -1) do
      delete news_entry_url(@news_entry)
    end
    assert_redirected_to news_entries_path
  end
end
