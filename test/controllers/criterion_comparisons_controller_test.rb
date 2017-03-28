require 'test_helper'

class CriterionComparisonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get criterion_comparisons_index_url
    assert_response :success
  end

end
