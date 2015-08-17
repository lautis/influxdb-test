class PingsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    ping = Origin.find_or_create_by_name(params[:origin]).pings.write(ping_params)
    if ping.persisted?
      render status: :created, json: ping
    else
      render status: 400, json: { message: 'could not create ping' }
    end
  end

  def hours
    origin = Origin.find_by(name: params[:id].to_s)
    if origin
      render json: origin.mean_transfer_times, root: false
    else
      render json: [], status: 404, root: false
    end
  end

  private

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
