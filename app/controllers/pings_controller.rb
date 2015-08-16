class PingsController < ApplicationController
  def create
    ping = Origin.find_or_create_by_name(params[:origin]).pings.write(ping_params)
    if ping.persisted?
      render status: :created, json: ping
    else
      render status: 400, json: { message: 'could not create ping' }
    end
  end

  def hours
    pings = Ping.where(origin: params[:id].to_s).time(:hour).select('mean(transfer_time_ms)')
    render json: pings.map(&method(:format_hourly_report)), root: false
  end

  private

  def format_hourly_report(data)
    {
      time: Time.at(data['time']),
      mean_transfer_time_ms: data['mean']
    }
  end

  def ping_params
    params.permit(
      :name_lookup_time_ms,
      :connect_time_ms,
      :transfer_time_ms,
      :total_time_ms,
      :status
    )
  end
end
