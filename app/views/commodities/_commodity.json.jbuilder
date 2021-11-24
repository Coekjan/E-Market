json.extract! commodity, :id, :name, :introduction, :price, :shop_id, :categories_id, :created_at, :updated_at
json.url commodity_url(commodity, format: :json)
