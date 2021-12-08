class Section < ApplicationRecord
  belongs_to :record
  has_many :comments

  def commodity
    record.order.commodity
  end
end
