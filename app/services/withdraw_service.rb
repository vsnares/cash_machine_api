class WithdrawService
  attr_reader :success, :result, :errors
  alias_method :success?, :success

  def initialize amount:
    @amount = amount.to_i
  end

  def run
    begin
      _check_params
      _check_balance
      _calculate_exchange_nominals
      _take_coins_nominals_from_storage
    rescue RuntimeError, ActiveRecord::RecordNotFound
      @errors
    end

    self
  end

  private

  def _check_params
    if @amount == 0
      @errors = { symbol: :check_params, message: "Params is invalid" }
      @success = false
      fail
    end
  end

  def _check_balance
    balance = Coin.pluck(:quantity, :denomination).map{|q, d| q * d}.sum

    unless balance >= @amount
      @errors = { symbol: :check_balance, message: "Not enaught coins in ATM" }
      @success = false
      fail
    end
  end

  def _calculate_exchange_nominals
    current_sum = @amount
    possible_solution = Hash.new

    Coin::KIND_OF_COINS.each do |current_nominal|
      possible_solution[current_nominal] = _get_possible_count_of_nominal current_sum, current_nominal
      current_sum -= current_nominal * possible_solution[current_nominal]
    end

    sum_of_possible_solution = possible_solution.map{|key, value| key * value}.sum

    if sum_of_possible_solution == @amount
      @result = possible_solution
      @success = true
    else
      @errors = { symbol: :calculate_exchange_nominals, message: "Can't exchage this denomination" }
      @success = false
      fail
    end
  end

  def _get_possible_count_of_nominal current_sum, denomination
    maximal_count = current_sum / denomination
    coin = Coin.find_by_denomination denomination
    coin.quantity < maximal_count ? coin.quantity : maximal_count
  end

  def _take_coins_nominals_from_storage
    @result.each do |key, value|
      coin = Coin.find_by_denomination key
      coin.update_attributes quantity: (coin.quantity - value)
    end
  end
end
