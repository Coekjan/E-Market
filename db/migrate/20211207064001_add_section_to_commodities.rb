class AddSectionToCommodities < ActiveRecord::Migration[5.2]
  def change
    add_reference :commodities, :section, foreign_key: true
  end
end
