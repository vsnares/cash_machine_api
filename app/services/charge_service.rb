class ChargeService
  attr_reader :success, :result, :errors
  alias_method :success?, :success

  def initialize hash_of_coins
    @hash_of_coins = hash_of_coins
  end

  def run
    if _check_hash_of_coins
       _add_coins
       @success = true
       @result = _balance
    else
      @success = false
      @errors = { message: "Denominations of coins are incorect" }
    end
    self
  end

  private

  def _check_hash_of_coins
    sorted_hash = @hash_of_coins.keys.map(& :to_i).sort
   (Coin::KIND_OF_COINS.sort & sorted_hash) == sorted_hash
  end

  def _add_coins
    @hash_of_coins.each do |denomination ,quantity|
      coin = Coin.find_by(denomination: denomination.to_i)
      if coin.nil?
        next
      else
        coin.update(quantity: coin.quantity + quantity.to_i)
      end
    end
  end

  def _balance
    Coin.pluck(:quantity, :denomination).map{|q, d| q * d}.sum
  end
end
