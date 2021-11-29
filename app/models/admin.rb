class Admin < ApplicationRecord
  belongs_to :account, dependent: :destroy
end
