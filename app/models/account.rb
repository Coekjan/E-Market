class Account < ApplicationRecord
  belongs_to :role
  has_one :admin, dependent: :destroy
  has_one :seller, dependent: :destroy
  has_one :customer, dependent: :destroy
end
