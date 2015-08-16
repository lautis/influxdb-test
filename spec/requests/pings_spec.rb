require 'rails_helper'

RSpec.describe 'Pings', type: :request do
  describe 'POST /api/1/pings' do
    let(:origin) { SecureRandom.hex }
    let(:payload) { ping(origin) }

    it 'returns 201 created' do
      post pings_path, payload
      expect(response).to be_success
    end

    it 'writes ping to influxdb' do
      post pings_path, payload
      sleep 2 # Eventual consistency...
      expect(Ping.where(origin: origin).length).to eql(1)
    end
  end

  describe 'GET /api/1/pings/:origin/hours' do
    let(:origin) { SecureRandom.hex }
    let(:pings) do
      [ping(origin, 2.hours.ago), ping(origin, 1.hour.ago), ping(origin, Time.current)]
    end

    before :each do
      pings.each do |ping|
        Ping.write(ping)
      end
      sleep 2 # Eventual consistency...
    end

    it 'returns pings by hour' do
      get hours_ping_path(origin)
      data = JSON.load(response.body)
      expect(data).to eql(pings.reverse.map do |ping|
        {
          'time' => Time.at(ping[:time]).beginning_of_hour.as_json,
          'mean_transfer_time_ms' => ping[:transfer_time_ms]
        }
      end)
    end
  end

  def ping(origin, time = Time.current)
    name_lookup_time_ms = rand(0..1000)
    transfer_time_ms = rand(0..1000)
    connect_time_ms = rand(0..1000)

    {
      origin: origin,
      name_lookup_time_ms: name_lookup_time_ms,
      connect_time_ms: connect_time_ms,
      transfer_time_ms: transfer_time_ms,
      total_time_ms: name_lookup_time_ms + connect_time_ms + transfer_time_ms,
      time: time.to_f,
      status: 200
    }
  end
end
