json.array!(@destroys) do |destroy|
  json.extract! destroy, :id, :membership
  json.url destroy_url(destroy, format: :json)
end
