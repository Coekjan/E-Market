json.extract! complaint, :id, :customer_id, :seller_id, :content, :admin_id, :created_at, :updated_at
json.url complaint_url(complaint, format: :json)
