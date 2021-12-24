class Seller < ApplicationRecord
  belongs_to :account
  has_many :complaints
  has_many :shops, dependent: :destroy
end
