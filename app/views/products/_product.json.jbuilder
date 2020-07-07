json.extract! product, :id, :supplier_name, :receipt_number, :name, :quantity, :created_at, :updated_at
json.url product_url(product, format: :json)
