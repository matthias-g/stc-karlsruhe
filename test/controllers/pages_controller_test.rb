require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do

  end

  test "kontakt" do
    get '/kontakt'
  end

  test "contact" do
    get '/contact'
  end

  test "about" do
    get '/about'
  end

  test "faq" do
    get '/faq'
  end
end
