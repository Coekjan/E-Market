class Comment < ApplicationRecord
  belongs_to :account
  belongs_to :section
  belongs_to :comment
  has_many :comments, dependent: :destroy
end
