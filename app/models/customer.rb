class Customer < ApplicationRecord
  belongs_to :account
  has_many :orders, dependent: :destroy
  has_many :complaints, dependent: :destroy
end
