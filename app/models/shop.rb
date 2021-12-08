class Shop < ApplicationRecord
  belongs_to :seller
  has_many :commodities, dependent: :destroy
end
