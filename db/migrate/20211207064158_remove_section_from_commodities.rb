class RemoveSectionFromCommodities < ActiveRecord::Migration[5.2]
  def change
    remove_reference :commodities, :section, foreign_key: true
  end
end
