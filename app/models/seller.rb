class Seller < ApplicationRecord
  belongs_to :account
  has_many :complaints, dependent: :destroy
  has_many :shops, dependent: :destroy
end
