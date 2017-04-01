require 'test_helper'

class ErrorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get error_index_url
    assert_response :success
  end

end
