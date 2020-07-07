json.extract! order, :id, :first_name, :last_name, :token, :status, :dispatch_priority, :created_at, :updated_at
json.url order_url(order, format: :json)
