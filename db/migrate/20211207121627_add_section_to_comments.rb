class AddSectionToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :section, foreign_key: true
  end
end
