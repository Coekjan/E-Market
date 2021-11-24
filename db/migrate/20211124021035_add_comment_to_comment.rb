class AddCommentToComment < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :comment, foreign_key: true
  end
end
