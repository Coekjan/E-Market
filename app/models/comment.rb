class Comment < ApplicationRecord
  belongs_to :account
  belongs_to :section
  belongs_to :comment
  has_many :comments
  validates :content, presence: true

  def destroy
    comments.filter { |c| c != self }.each { |c| c.destroy }
    super
  end
end
