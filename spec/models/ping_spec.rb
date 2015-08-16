require 'rails_helper'

RSpec.describe Ping, type: :model do
  it 'writes to influxdb' do
    ping = Ping.write(
      origin: SecureRandom.hex,
      name_lookup_time_ms: 14,
      connect_time_ms: 691,
      transfer_time_ms: 228,
      total_time_ms: 934,
      time: Time.current.to_f,
      status: 200
    )

    expect(ping).to be_persisted
  end
end
