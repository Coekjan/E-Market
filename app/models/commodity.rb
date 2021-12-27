class Commodity < ApplicationRecord
  belongs_to :shop
  has_and_belongs_to_many :categories, dependent: :destroy
  validates :name, :price, :introduction, presence: true

  def sections
    Section.all.filter { |s| s.commodity == self }
  end
end
