pings = JSON.load(File.open(Rails.root.join('pings.json')))

pings.each do |ping|
  Origin.find_or_create_by_name(ping['origin']).pings.write(
    origin: ping['origin'],
    name_lookup_time_ms: ping['name_lookup_time_ms'],
    connect_time_ms: ping['name_lookup_time_ms'],
    transfer_time_ms: ping['transfer_time_ms'],
    total_time_ms: ping['total_time_ms'],
    time: Time.zone.parse(ping['created_at']).to_f,
    status: ping['status']
  )
end
