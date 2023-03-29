require "test_helper"

class ForcastControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forcast_index_url
    assert_response :success
  end
end
