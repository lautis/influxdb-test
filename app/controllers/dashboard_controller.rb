class DashboardController < ApplicationController
  def index
    @origins = Origin.all.sort_by(&:name)
  end
end
