require 'test_helper'

class ChargeServiceTest < ActiveSupport::TestCase

  setup do
    @valid_params   =  { "50" => "8", "25" => "4" }
    @invalid_params =  { "text" => "text11", "text2" => "text22" }
    @invalid_params2 = { "6" => "10", "20" => "15" }
  end

  test 'should charge cash machine' do
    service = ChargeService.new(@valid_params).run
    assert service.success?
    assert_equal 1430, service.result
  end

  test 'should not charge cash machine with string params' do
    service = ChargeService.new(@invalid_params).run
    refute service.success?
    assert_equal "Denominations of coins are incorect", service.errors[:message]
  end

  test 'should not charge cash machine with incorect denomination' do
    service = ChargeService.new(@invalid_params2).run
    refute service.success?
    assert_equal "Denominations of coins are incorect", service.errors[:message]
  end
  
end
