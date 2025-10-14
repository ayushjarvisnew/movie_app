class SeatsController < ApplicationController
  before_action :set_screen, only: [:index]

  def index
    seats = @screen ? @screen.seats.order(:row, :seat_number) : Seat.order(:screen_id, :row, :seat_number)
    render json: seats.as_json(only: [:id, :screen_id, :row, :seat_number, :seat_type, :price, :available])
  end

  def create
    seat = Seat.new(seat_params)
    if seat.save
      render json: seat, status: :created
    else
      render json: { errors: seat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_screen
    @screen = Screen.find_by(id: params[:screen_id]) if params[:screen_id].present?
  end

  def seat_params
    params.require(:seat).permit(:screen_id, :row, :seat_number, :seat_type, :price, :available)
  end
end