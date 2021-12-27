class Section < ApplicationRecord
  belongs_to :record
  has_many :comments, dependent: :destroy
  validates :grade, presence: true

  def commodity
    record.order.commodity
  end
end
