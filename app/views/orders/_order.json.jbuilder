json.extract! order, :id, :count, :price, :done, :commodity_id, :seller_id, :created_at, :updated_at
json.url order_url(order, format: :json)
