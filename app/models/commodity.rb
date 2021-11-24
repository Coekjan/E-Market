class Commodity < ApplicationRecord
  belongs_to :shop
  has_and_belongs_to_many :categories
end
