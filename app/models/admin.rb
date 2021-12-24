class Admin < ApplicationRecord
  belongs_to :account, dependent: :destroy
  has_many :complaints
end
