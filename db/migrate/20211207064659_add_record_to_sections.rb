class AddRecordToSections < ActiveRecord::Migration[5.2]
  def change
    add_reference :sections, :record, foreign_key: true
  end
end
