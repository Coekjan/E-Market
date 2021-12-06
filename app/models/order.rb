class Order < ApplicationRecord
  belongs_to :commodity
  belongs_to :customer
end
