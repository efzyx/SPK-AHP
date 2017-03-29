require 'test_helper'

class ALternaticeCriterionComparisonControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get a_lternatice_criterion_comparison_index_url
    assert_response :success
  end

end
