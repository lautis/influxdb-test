require 'rails_helper'

RSpec.describe 'Pings', type: :request do
  describe 'POST /api/1/pings' do
    let(:origin) { SecureRandom.hex }
    let(:payload) do
      {
        origin: origin,
        name_lookup_time_ms: 14,
        connect_time_ms: 691,
        transfer_time_ms: 228,
        total_time_ms: 934,
        status: 200
      }
    end

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
end
