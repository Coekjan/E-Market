class Record < ApplicationRecord
  belongs_to :order
  has_one :section
end
