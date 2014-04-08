json.array!(@users) do |user|
  json.extract! user, :id, :username, :forename, :lastname, :email
  json.url user_url(user, format: :json)
end
