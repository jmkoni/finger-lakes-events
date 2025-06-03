json.extract! event, :id, :time, :url, :description, :type, :tags, :cost, :approved, :approved_by, :created_at, :updated_at
json.url event_url(event, format: :json)
