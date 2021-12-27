json.extract! shop, :id, :name, :introduction, :seller_id, :created_at, :updated_at
json.url seller_shop_url(seller, shop, format: :json)
