class ReservationsController < ApplicationController
  before_action :authorize_request
  before_action :require_admin, only: [:index]
  before_action :set_reservation, only: [:destroy, :restore]

  def my_reservations
    reservations = @current_user.reservations.includes(showtime: [:movie, :screen, { theatre: :screens }], seats: [])
    render json: reservations.map { |r| format_reservation(r) }
  end

  def create
    seat_ids = reservation_params[:seat_ids]&.map(&:to_i) || []
    showtime = Showtime.find_by(id: reservation_params[:showtime_id])
    return render json: { error: "Showtime not found" }, status: :not_found unless showtime
    return render json: { error: "Select at least one seat" }, status: :unprocessable_entity if seat_ids.empty?

    showtime_seats = ShowtimeSeat.where(showtime_id: showtime.id, seat_id: seat_ids, available: true)
    if showtime_seats.size != seat_ids.size
      return render json: { error: "Some selected seats are not available" }, status: :unprocessable_entity
    end

    seats = showtime_seats.map(&:seat)
    total_amount = seats.sum { |s| s.price.to_f }

    ActiveRecord::Base.transaction do
      showtime_seats.lock! # prevent double booking

      txnid = "TXN#{SecureRandom.hex(8)}" # ✅ generate a unique transaction ID

      reservation = @current_user.reservations.create!(
        showtime: showtime,
        total_amount: total_amount,
        payment_status: "pending",
        txnid: txnid
      )

      reservation.seats << seats

      showtime_seats.update_all(available: false)
      showtime.update_available_seats!

      render json: format_reservation(reservation).merge(txnid: txnid), status: :created
    end


  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  def index
    reservations = if @current_user.is_admin
                     Reservation.includes(showtime: [:movie, :screen, { theatre: :screens }], seats: [], user: []).all
                   else
                     @current_user.reservations.includes(showtime: [:movie, :screen, { theatre: :screens }], seats: [])
                   end

    render json: reservations.map { |r| format_reservation(r, include_user: @current_user.is_admin) }
  end


  def destroy
    if @reservation.showtime.nil?

      @reservation.destroy
      return render json: { message: "Reservation soft-deleted (showtime missing)" }
    end

    if @reservation.showtime.start_time > Time.current
      ActiveRecord::Base.transaction do

        ShowtimeSeat.where(
          showtime_id: @reservation.showtime_id,
          seat_id: @reservation.seat_ids
        ).update_all(available: true)

        @reservation.showtime.update_available_seats!

        @reservation.destroy
      end
      render json: { message: "Reservation cancelled successfully" }
    else
      render json: { error: "Cannot cancel past reservations" }, status: :forbidden
    end
  end



  def restore
    if @reservation.deleted_at.present?
      ActiveRecord::Base.transaction do
        ShowtimeSeat.where(showtime_id: @reservation.showtime_id, seat_id: @reservation.seat_ids).update_all(available: false)
        @reservation.showtime.update_available_seats!
        @reservation.restore
      end
      render json: { message: "Reservation restored successfully" }
    else
      render json: { error: "Reservation is not deleted" }, status: :unprocessable_entity
    end
  end

  private

  def set_reservation
    @reservation = if @current_user.is_admin
                     Reservation.find_by(id: params[:id])
                   else
                     @current_user.reservations.find_by(id: params[:id])
                   end
    render json: { error: "Reservation not found" }, status: :not_found unless @reservation
  end

  def reservation_params
    params.require(:reservation).permit(:showtime_id, seat_ids: [])
  end


  def format_reservation(reservation, include_user: false)
    showtime = reservation.showtime
    screen = showtime&.screen
    theatre = screen&.theatre

    data = {
      id: reservation.id,
      movie_title: showtime&.movie&.title || "N/A",
      theatre_name: theatre&.name || "N/A",
      showtime_time: showtime&.start_time ? showtime.start_time.in_time_zone("Asia/Kolkata").strftime("%d %b %Y, %H:%M") : "N/A",
      seats: reservation.seats.map { |s| "#{s.row}#{s.seat_number}" },
      total_amount: reservation.total_amount,
      payment_status: reservation.payment_status,
      cancelled: reservation.deleted_at.present?
    }

    if include_user
      data[:user_name] = reservation.user&.name
      data[:user_email] = reservation.user&.email
    end

    data
  end

  def show_by_txn
    reservation = Reservation.find_by(txnid: params[:txnid])

    if reservation
      showtime = reservation.showtime
      movie = showtime.movie
      theatre = showtime.screen.theatre
      seats = reservation.seats.map { |s| "#{s.row}#{s.seat_number}" }

      render json: {
        booking: {
          txnid: reservation.txnid,
          movie: movie.title,
          theatre: theatre.name,
          showtime: showtime.start_time.in_time_zone("Asia/Kolkata").strftime("%d %b %Y, %H:%M"),
          seats: seats,
          amount: reservation.total_amount,
          payment_status: reservation.payment_status
        }
      }
    else
      render json: { error: "Booking not found" }, status: :not_found
    end
  end

end

