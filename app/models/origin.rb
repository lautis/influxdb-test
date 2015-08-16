class Origin < ActiveRecord::Base
  class << self
    def find_or_create_by_name(name)
      find_or_create_by(name: name)
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end

  def pings
    Influxer::Relation.new(Ping, attributes: { origin: name })
  end

  def mean_transfer_times
    series_name = Ping.quoted_series("mean_transfer_time.pings_origin_#{name}")
    query = "SELECT * FROM #{series_name}"
    Influxer.client.query(query).values.first
      .select { |data| data['time'] > 0 }
      .map(&method(:format_mean_transfer_time))
  end

  private

  def format_mean_transfer_time(data)
    {
      time: Time.zone.at(data['time'].to_i),
      mean_transfer_time_ms: data['mean']
    }
  end
end
