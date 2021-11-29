class Seller < ApplicationRecord
  belongs_to :account
  has_many :shops
end
