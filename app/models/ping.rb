class Ping < Influxer::Metrics
  set_series :pings
  fanout :origin

  attributes :name_lookup_time_ms,
             :connect_time_ms,
             :transfer_time_ms,
             :total_time_ms,
             :origin,
             :status
end
