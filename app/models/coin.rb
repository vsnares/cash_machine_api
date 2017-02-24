class Coin < ApplicationRecord
  KIND_OF_COINS = [ 50, 25, 10, 5, 2, 1 ]

  validates :quantity, :denomination, presence: true
  validates :denomination, uniqueness: true

  validates :denomination, inclusion: KIND_OF_COINS
end
