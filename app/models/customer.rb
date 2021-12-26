class Customer < ApplicationRecord
  belongs_to :account
  has_many :orders
  has_many :complaints, dependent: :destroy
end
