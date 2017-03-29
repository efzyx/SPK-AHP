require 'test_helper'

class AlternativeCriterionComparisonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get alternative_criterion_comparisons_index_url
    assert_response :success
  end

end
