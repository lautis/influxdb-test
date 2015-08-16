namespace :influx do
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
end

Rake::Task['db:create'].enhance(['influx:create'])
Rake::Task['db:drop'].enhance(['influx:drop'])
