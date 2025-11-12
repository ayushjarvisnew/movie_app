# class PaymentsController < ApplicationController
#   skip_forgery_protection only: [:initiate, :success, :failure]
#   before_action :authorize_request, only: [:initiate]
#
#   require "digest"
#
#   def initiate
#     return render json: { error: "User not logged in" }, status: :unauthorized unless current_user
#     return render json: { error: "Admins cannot book tickets" }, status: :forbidden if current_user.is_admin
#
#
#     txnid = "TXN#{Time.now.to_i}#{(Time.now.usec / 1000).to_i}#{rand(1000..9999)}"
#     key = ENV.fetch("PAYU_KEY", "IkRmcc")
#     salt = ENV.fetch("PAYU_SALT", "HYly8Qb0tP5qp46MPusFBdiTYWIjbuDf")
#
#     amount = params[:amount]
#     productinfo = params[:productinfo]
#     firstname = params[:firstname]
#     email = params[:email]
#     phone = params[:phone]
#     seat_ids = params[:seat_ids] || []
#     showtime_id = params[:showtime_id]
#
#     return render json: { error: "No seats selected" }, status: :unprocessable_entity if seat_ids.empty?
#     return render json: { error: "Amount missing" }, status: :unprocessable_entity unless amount.present?
#
#     recent_reservation = Reservation.where(
#       user_id: current_user.id,
#       showtime_id: params[:showtime_id],
#       payment_status: "pending"
#     ).where("created_at >= ?", 1.minute.ago).first
#
#     if recent_reservation
#       return render json: { error: "You already have a pending payment. Try again after a minute." }, status: :too_many_requests
#     end
#
#     showtime_seats = ShowtimeSeat.where(showtime_id: params[:showtime_id], seat_id: seat_ids, available: true)
#
#     if showtime_seats.empty?
#       return render json: { error: "Selected seats are not available" }, status: :unprocessable_entity
#     end
#
#     hash_string = "#{key}|#{txnid}|#{amount}|#{productinfo}|#{firstname}|#{email}|||||||||||#{salt}"
#     hash = Digest::SHA512.hexdigest(hash_string)
#
#     reservation = Reservation.create!(
#       user_id: current_user.id,
#       showtime_id: params[:showtime_id],
#       txnid: txnid,
#       total_amount: amount,
#       payment_status: "pending",
#       seats_count: 0
#     )
#
#     reservation.seats << showtime_seats.map(&:seat)
#     showtime_seats.update_all(available: false)
#
#     render json: {
#       key: key,
#       txnid: txnid,
#       hash: hash,
#       amount: amount,
#       firstname: firstname,
#       email: email,
#       phone: phone,
#       productinfo: productinfo,
#       surl: "http://localhost:3000/payment-success",
#       furl: "http://localhost:3000/payment-failure",
#       action: "https://test.payu.in/_payment"
#     }
#
#   rescue => e
#     Rails.logger.error("Payment initiation error: #{e.full_message}")  # Full stack trace
#     render json: { error: e.message, backtrace: e.backtrace }, status: :internal_server_error
#   end
#
#
#   def success
#     txnid = params[:txnid]
#     status = params[:status]
#     reservation = Reservation.find_by(txnid: txnid)
#
#     if reservation && status == "success"
#       reservation.update(payment_status: "success")
#
#       ShowtimeSeat.where(showtime_id: reservation.showtime_id, seat_id: reservation.seats.pluck(:id))
#                   .update_all(available: false)
#
#       respond_to do |format|
#         format.html do
#           redirect_to "http://localhost:3000/payments/success?txnid=#{txnid}&status=success"
#         end
#         format.json do
#           render json: {
#             booking: {
#               txnid: reservation.txnid,
#               movie: reservation.showtime&.movie&.title || "N/A",
#               theatre: reservation.showtime&.screen&.theatre&.name || "N/A",
#               showtime: reservation.showtime&.start_time,
#               seats: reservation.seats.map { |s| "#{s.row}#{s.seat_number}" },
#               amount: reservation.total_amount
#             }
#           }
#         end
#       end
#     else
#       respond_to do |format|
#         format.html do
#           redirect_to "http://localhost:3000/payments/failure?txnid=#{txnid}&status=failure"
#         end
#         format.json { render json: { error: "No booking found" }, status: :not_found }
#       end
#     end
#   end
#
#
#   def failure
#     txnid = params[:txnid]
#     reservation = Reservation.find_by(txnid: txnid)
#     if reservation
#     reservation.update(payment_status: "failed")
#     ShowtimeSeat.where(showtime_id: reservation.showtime_id, seat_id: reservation.seats.pluck(:id))
#                 .update_all(available: true)
#   end
#     redirect_to "http://localhost:3000/payments/failure?txnid=#{txnid}&status=failure"
#   end
# end
#


class PaymentsController < ApplicationController
  skip_forgery_protection only: [:initiate, :success, :failure]
  before_action :authorize_request, only: [:initiate]

  require "digest"

  def initiate
    return render json: { error: "User not logged in" }, status: :unauthorized unless current_user
    return render json: { error: "Admins cannot book tickets" }, status: :forbidden if current_user.is_admin

    txnid = "TXN#{Time.now.to_i}#{(Time.now.usec / 1000).to_i}#{rand(1000..9999)}"
    key = ENV.fetch("PAYU_KEY", "IkRmcc")
    salt = ENV.fetch("PAYU_SALT", "HYly8Qb0tP5qp46MPusFBdiTYWIjbuDf")

    amount = params[:amount]
    productinfo = params[:productinfo]
    firstname = params[:firstname]
    email = params[:email]
    phone = params[:phone]
    seat_ids = params[:seat_ids] || []
    showtime_id = params[:showtime_id]

    return render json: { error: "No seats selected" }, status: :unprocessable_entity if seat_ids.empty?
    return render json: { error: "Amount missing" }, status: :unprocessable_entity unless amount.present?

    recent_reservation = Reservation.where(
      user_id: current_user.id,
      showtime_id: params[:showtime_id],
      payment_status: "pending"
    ).where("created_at >= ?", 1.minute.ago).first

    if recent_reservation
      return render json: { error: "You already have a pending payment. Try again after a minute." }, status: :too_many_requests
    end

    showtime_seats = ShowtimeSeat.where(showtime_id: params[:showtime_id], seat_id: seat_ids, available: true)

    if showtime_seats.empty?
      return render json: { error: "Selected seats are not available" }, status: :unprocessable_entity
    end

    hash_string = "#{key}|#{txnid}|#{amount}|#{productinfo}|#{firstname}|#{email}|||||||||||#{salt}"
    hash = Digest::SHA512.hexdigest(hash_string)

    reservation = Reservation.create!(
      user_id: current_user.id,
      showtime_id: params[:showtime_id],
      txnid: txnid,
      total_amount: amount,
      payment_status: "pending",
      seats_count: 0
    )

    reservation.seats << showtime_seats.map(&:seat)
    showtime_seats.update_all(available: false)

    # ✅ Choose correct base URL
    base_url =
      if Rails.env.production?
        "https://movie-app-3cv5.onrender.com"
      else
        "http://localhost:3000"
      end

    render json: {
      key: key,
      txnid: txnid,
      hash: hash,
      amount: amount,
      firstname: firstname,
      email: email,
      phone: phone,
      productinfo: productinfo,
      surl: "#{base_url}/payments/success",
      furl: "#{base_url}/payments/failure",
      action: "https://test.payu.in/_payment"
    }

  rescue => e
    Rails.logger.error("Payment initiation error: #{e.full_message}")
    render json: { error: e.message, backtrace: e.backtrace }, status: :internal_server_error
  end

  def success
    txnid = params[:txnid]
    status = params[:status]
    reservation = Reservation.find_by(txnid: txnid)

    base_url =
      if Rails.env.production?
        "https://movie-app-3cv5.onrender.com"
      else
        "http://localhost:3000"
      end

    if reservation && status == "success"
      reservation.update(payment_status: "success")
      ShowtimeSeat.where(showtime_id: reservation.showtime_id, seat_id: reservation.seats.pluck(:id))
                  .update_all(available: false)

      respond_to do |format|
        format.html { redirect_to "#{base_url}/payments/success?txnid=#{txnid}&status=success" }
        format.json do
          render json: {
            booking: {
              txnid: reservation.txnid,
              movie: reservation.showtime&.movie&.title || "N/A",
              theatre: reservation.showtime&.screen&.theatre&.name || "N/A",
              showtime: reservation.showtime&.start_time,
              seats: reservation.seats.map { |s| "#{s.row}#{s.seat_number}" },
              amount: reservation.total_amount
            }
          }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to "#{base_url}/payments/failure?txnid=#{txnid}&status=failure" }
        format.json { render json: { error: "No booking found" }, status: :not_found }
      end
    end
  end

  def failure
    txnid = params[:txnid]
    reservation = Reservation.find_by(txnid: txnid)
    reservation&.update(payment_status: "failed")
    ShowtimeSeat.where(showtime_id: reservation.showtime_id, seat_id: reservation.seats.pluck(:id))
                .update_all(available: true) if reservation

    base_url =
      if Rails.env.production?
        "https://movie-app-3cv5.onrender.com"
      else
        "http://localhost:3000"
      end

    redirect_to "#{base_url}/payments/failure?txnid=#{txnid}&status=failure"
  end
end
