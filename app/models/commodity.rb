class Commodity < ApplicationRecord
  belongs_to :shop
  has_and_belongs_to_many :categories, dependent: :destroy
  validates :name, :price, :introduction, presence: true
  scope :filter_by_categories, -> (cset) {
    reject { |c|
      (c.category_ids.map(&:to_i) & cset.reject(&:blank?).map(&:to_i)).empty?
    }
  }

  def sections
    Section.all.filter { |s| s.commodity == self }
  end
end
