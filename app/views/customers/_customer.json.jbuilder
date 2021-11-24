json.extract! customer, :id, :account_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)
