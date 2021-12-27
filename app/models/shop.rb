class Shop < ApplicationRecord
  belongs_to :seller
  has_many :commodities, dependent: :destroy
  validates :name, :introduction, presence: true
end
