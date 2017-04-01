require 'test_helper'

class TentangControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tentang_index_url
    assert_response :success
  end

end
