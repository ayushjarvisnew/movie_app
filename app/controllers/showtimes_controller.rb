class ShowtimesController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy, :book_seats]
  before_action :set_showtime, only: [:show, :update, :destroy, :available_seats, :book_seats]

  def index
    showtimes = Showtime.includes(:movie, :screen).active
    showtimes = showtimes.where("DATE(start_time) = ?", params[:date]) if params[:date].present?
    render json: showtimes.as_json(include: [:movie, :screen])
  end

  def show
    render json: @showtime.as_json(include: [:movie, :screen])
  end


  def create
    showtime = Showtime.new(showtime_params)
    showtime.available_seats = showtime.screen.total_seats if showtime.screen.present? # auto-set from screen
    if showtime.save
      render json: showtime.as_json(include: [:movie, :screen]), status: :created
    else
      render json: { errors: showtime.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @showtime.update(showtime_params)
      render json: @showtime.as_json(include: [:movie, :screen])
    else
      render json: { errors: @showtime.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @showtime.soft_delete
    render json: { message: "Showtime deleted" }, status: :ok
  end

  def available_seats
    all_seats = @showtime.screen.seats.active
    reserved_ids = @showtime.reservations.joins(:seats).pluck('seats.id')

    seats_with_availability = all_seats.map do |s|
      {
        id: s.id,
        row: s.row,
        seat_number: s.seat_number,
        seat_type: s.seat_type,
        price: s.price,
        available: !reserved_ids.include?(s.id)
      }
    end

    render json: seats_with_availability
  end

  def book_seats
    seat_ids = params[:seat_ids]&.map(&:to_i) || []
    if seat_ids.empty?
      return render json: { error: "No seats selected" }, status: :unprocessable_content
    end

    seats = @showtime.screen.seats.active.where(id: seat_ids)
    reserved_ids = @showtime.reservations.joins(:seats).pluck('seats.id')
    already_reserved = seat_ids & reserved_ids

    if already_reserved.any?
      return render json: { error: "Some seats are already reserved", seats: already_reserved }, status: :unprocessable_content
    end

    ActiveRecord::Base.transaction do
      seats.lock!
      total_amount = seats.map { |s| s.price.to_f }.sum

      # Create reservation without seats column
      reservation = Reservation.create!(
        user: @current_user,
        showtime: @showtime,
        total_amount: total_amount,
        payment_status: "pending"
      )


      reservation.seats << seats


      seats.update_all(available: false)

      render json: reservation.as_json(
        include: { seats: {}, showtime: { include: [:movie, :screen] } }
      ), status: :created
    end

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.join(", ") }, status: :unprocessable_content
  rescue => e
    render json: { error: e.message }, status: :unprocessable_content
  end

  private

  def set_showtime
    @showtime = Showtime.active.find_by(id: params[:id])
    render json: { error: "Showtime not found" }, status: :not_found unless @showtime
  end

  def showtime_params
    # Remove available_seats from frontend params to prevent unpermitted error
    params.require(:showtime).permit(:movie_id, :screen_id, :start_time, :end_time, :language)
  end
end
