require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test 'simple format urls in markdown inline-style' do
    html = simple_format_urls 'join [Serve the City](https://servethecity-karlsruhe.de)!'
    assert_equal 'join <a href="https://servethecity-karlsruhe.de" target="_blank">Serve the City</a>!', html
  end

  test 'simple format urls in angle brackets' do
    html = simple_format_urls 'join <https://servethecity-karlsruhe.de>!'
    assert_equal 'join <a href="https://servethecity-karlsruhe.de" target="_blank">https://servethecity-karlsruhe.de</a>!', html
  end

end
