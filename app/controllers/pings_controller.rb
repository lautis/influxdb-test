class PingsController < ApplicationController
  def create
    ping = Ping.write(ping_params)
    if ping.persisted?
      render status: :created, json: ping
    else
      render status: 400, json: { message: 'could not create ping' }
    end
  end

  private

  def ping_params
    params.permit(
      :name_lookup_time_ms,
      :connect_time_ms,
      :transfer_time_ms,
      :total_time_ms,
      :origin,
      :status
    )
  end
end
