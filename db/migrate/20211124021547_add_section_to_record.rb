class AddSectionToRecord < ActiveRecord::Migration[5.2]
  def change
    add_reference :records, :section, foreign_key: true
  end
end
