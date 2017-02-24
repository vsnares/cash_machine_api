require 'test_helper'

class WithdrawServiceTest < ActiveSupport::TestCase
  setup do
    @valid_params    = "253"
    @invalid_params  = "banana45"
    @invalid_params2 = "96"
  end

  test 'should withdraw some coins' do
    service = WithdrawService.new(amount: @valid_params).run
    assert service.success?
    assert_equal service.result, {50=>5, 25=>0, 10=>0, 5=>0, 2=>1, 1=>1}
  end

  test 'should not withdraw some coins' do
    service = WithdrawService.new(amount: @invalid_params).run
    refute service.success?
    assert_equal service.errors[:message], "Params is invalid"
  end

  test 'should not withdraw some coins with necessary denomination' do
    Coin.last(5).each { |coin| coin.update(quantity: 0) }
    service = WithdrawService.new(amount: @invalid_params2).run
    refute service.success?
    assert_equal "Not enaught coins in ATM", service.errors[:message]
  end
end
