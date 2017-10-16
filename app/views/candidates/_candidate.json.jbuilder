json.extract! candidate, :id, :first_name, :last_name, :email, :created_at, :updated_at
json.url candidate_url(candidate, format: :json)
