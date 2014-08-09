json.array!(@guests) do |guest|
  json.extract! guest, :id, :phone_number, :city, :state, :zip, :country
  json.url guest_url(guest, format: :json)
end
