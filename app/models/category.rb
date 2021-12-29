class Category < ApplicationRecord
  has_and_belongs_to_many :commodities
  has_one_attached :image, dependent: :destroy
  validates :image, attached: true, content_type: [:jpg, :png, :jpeg], size: { less_than: 5.megabytes }
end
