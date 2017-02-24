require 'test_helper'

class WithdrawIntegrationTest < ActionDispatch::IntegrationTest

  test "withdraw success" do
    post api_withdraw_path,
         params: { sum: 200 }
    assert_response :success
    assert_equal JSON(@response.body)["result"], {"50"=>4, "25"=>0, "10"=>0, "5"=>0, "2"=>0, "1"=>0}
  end

  test "withdraw fail" do
    post api_withdraw_path,
      params: { sum: "pillow" }
    assert_response 422
    assert_equal JSON(@response.body)["errors"], "Params is invalid"
  end
end
