namespace :influxdb do
  task create: :environment do
    Influxer.client.create_database(Influxer.config.database)
  end

  task drop: :environment do
    begin
      Influxer.client.delete_database(Influxer.config.database)
    rescue InfluxDB::Error
      # Database likely doesn't exist
    end
  end

  task continuous_queries: :environment do
    query = 'select from "pings" group by time(1h)'
    Influxer.client.create_continuous_query('SELECT * FROM pings', 'pings_origin_[origin]')
    Influxer.client.create_continuous_query('SELECT mean(transfer_time_ms) FROM /^pings_origin_.*/ GROUP BY time(1h)', 'mean_transfer_time.:series_name')
  end
end

Rake::Task['db:create'].enhance(['influxdb:create'])
Rake::Task['db:drop'].enhance(['influxdb:drop'])
Rake::Task['db:schema:load'].enhance(['influxdb:continuous_queries'])
