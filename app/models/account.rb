class Account < ApplicationRecord
  has_one :admin, dependent: :destroy
  has_one :seller, dependent: :destroy
  has_one :customer, dependent: :destroy
  validates :name, :password, presence: true
end
