class ShowtimesController < ApplicationController
  before_action :authorize_request, only: [:book_seats, :create, :update, :destroy]
  before_action :require_admin, only: [:create, :update, :destroy]
  before_action :set_showtime, only: [:show, :available_seats, :book_seats, :update, :destroy]

  # GET /showtimes?movie_id=1&date=YYYY-MM-DD
  def index
    showtimes = Showtime.includes(:movie, :screen).active
    showtimes = showtimes.where(movie_id: params[:movie_id]) if params[:movie_id].present?

    if params[:date].present?
      date = params[:date].to_date
      showtimes = showtimes.where(start_time: date.beginning_of_day..date.end_of_day)
    end

    render json: showtimes.map { |st| showtime_json(st) }
  end

  # GET /showtimes/:id
  def show
    render json: showtime_json(@showtime)
  end

  # GET /showtimes/:id/seats
  def available_seats
    seats = @showtime.screen.seats.order(:row, :seat_number)
    booked_seat_ids = @showtime.reservations.joins(:seats).pluck("seats.id")

    render json: seats.map do |s|
      {
        id: s.id,
        row: s.row,
        seat_number: s.seat_number,
        seat_type: s.seat_type,
        price: s.price,
        available: !booked_seat_ids.include?(s.id)
      }
    end
  end

  # POST /showtimes/:id/book_seats
  def book_seats
    seat_ids = params[:seat_ids]&.map(&:to_i) || []
    if seat_ids.empty?
      return render json: { error: "Select at least one seat" }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      # Lock selected seats to prevent race conditions
      seats = @showtime.screen.seats.where(id: seat_ids).lock
      booked_ids = @showtime.reservations.joins(:seats).pluck("seats.id")
      unavailable = seat_ids & booked_ids

      if unavailable.any?
        return render json: { error: "Some seats are already booked", seat_ids: unavailable }, status: :unprocessable_entity
      end

      total_amount = seats.sum(&:price)

      reservation = @current_user.reservations.create!(
        showtime: @showtime,
        total_amount: total_amount,
        payment_status: "pending"
      )

      reservation.seats << seats
      @showtime.update_available_seats!

      render json: {
        reservation_id: reservation.id,
        movie_title: @showtime.movie.title,
        showtime: @showtime.start_time.in_time_zone("Asia/Kolkata").strftime("%d %b %Y, %H:%M"),
        theatre: @showtime.screen.theatre.name,
        screen: @showtime.screen.name,
        seats: seats.map { |s| "#{s.row}#{s.seat_number}" },
        total_amount: total_amount,
        payment_status: reservation.payment_status
      }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # Admin-only endpoints
  def create
    showtime = Showtime.new(showtime_params)
    showtime.available_seats = showtime.screen.total_seats if showtime.screen.present?
    if showtime.save
      render json: showtime_json(showtime), status: :created
    else
      render json: { errors: showtime.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @showtime.update(showtime_params)
      render json: showtime_json(@showtime)
    else
      render json: { errors: @showtime.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @showtime.soft_delete
    render json: { message: "Showtime deleted" }, status: :ok
  end

  private

  def set_showtime
    @showtime = Showtime.active.find_by(id: params[:id])
    render json: { error: "Showtime not found" }, status: :not_found unless @showtime
  end

  def showtime_params
    params.require(:showtime).permit(:movie_id, :screen_id, :start_time, :end_time, :language)
  end

  def showtime_json(showtime)
    {
      id: showtime.id,
      movie_id: showtime.movie_id,
      movie_title: showtime.movie.title,
      screen_id: showtime.screen_id,
      screen_name: showtime.screen.name,
      theatre_name: showtime.screen.theatre.name,
      start_time: showtime.start_time,
      end_time: showtime.end_time,
      language: showtime.language,
      available_seats: showtime.available_seats
    }
  end
end
