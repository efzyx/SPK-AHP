require 'test_helper'

class ALternativeCriterionComparisonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get a_lternative_criterion_comparisons_index_url
    assert_response :success
  end

end
