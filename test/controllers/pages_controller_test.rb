require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do

  end

  test 'kontakt' do
    get '/kontakt'
  end
end
