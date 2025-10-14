class HomeController < ApplicationController
  def index; end

  def api_status
    render json: { message: "Welcome to Movie Reservation API", time: Time.current }
  end
end