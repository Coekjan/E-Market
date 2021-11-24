json.extract! account, :id, :name, :password, :role_id, :balance, :created_at, :updated_at
json.url account_url(account, format: :json)
