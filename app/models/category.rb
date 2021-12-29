class Category < ApplicationRecord
  has_and_belongs_to_many :commodities
  has_one_attached :image, dependent: :destroy
end
