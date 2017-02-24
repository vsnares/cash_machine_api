require 'test_helper'

class ChargeIntegrationTest < ActionDispatch::IntegrationTest

  test "successful charge" do
    post api_charge_path,
       params: { hash_of_coins: { "50" => "2", "25" => "4" } }
    assert_response :success
    assert_equal JSON(@response.body)["balance"], 1130
  end

  test "failed charge" do
    post api_charge_path,
       params: { hash_of_coins: { "banana" => "half", "orange" => "4" } }
    assert_response 422
    assert_equal JSON(@response.body)["errors"], "Denominations of coins are incorect"
  end

end
