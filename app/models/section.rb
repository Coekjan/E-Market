class Section < ApplicationRecord
  belongs_to :record
  has_many :comments, dependent: :destroy

  def commodity
    record.order.commodity
  end
end
