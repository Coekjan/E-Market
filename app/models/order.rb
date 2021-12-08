class Order < ApplicationRecord
  belongs_to :commodity
  belongs_to :customer
  has_one :record, dependent: :destroy
end
