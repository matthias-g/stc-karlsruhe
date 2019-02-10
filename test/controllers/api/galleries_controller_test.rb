require 'test_helper'

class Api::GalleriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gallery = galleries(:default)
    @headers = { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' }
  end

  test "get gallery" do
    get api_gallery_path(@gallery) + "?include=gallery-pictures", headers: @headers
    assert_response :success
    response_data = JSON.parse(@response.body)['data']
    assert_equal @gallery.id, response_data['id'].to_i
  end
end
