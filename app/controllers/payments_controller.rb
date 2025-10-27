class PaymentsController < ApplicationController
  # protect_from_forgery except: [:initiate, :success, :failure]
  skip_forgery_protection only: [:initiate, :success, :failure]
  before_action :authorize_request, only: [:initiate]


  require "digest"

  def initiate
    return render json: { error: "User not logged in" }, status: :unauthorized unless current_user

    # Unique txnid: seconds + milliseconds + random number
    txnid = "TXN#{Time.now.to_i}#{(Time.now.usec / 1000).to_i}#{rand(1000..9999)}"

    key = ENV.fetch("PAYU_KEY", "IkRmcc")
    salt = ENV.fetch("PAYU_SALT", "HYly8Qb0tP5qp46MPusFBdiTYWIjbuDf")

    amount = params[:amount]
    productinfo = params[:productinfo]
    firstname = params[:firstname]
    email = params[:email]
    phone = params[:phone]
    seat_ids = params[:seat_ids] || []

    # Validations
    return render json: { error: "No seats selected" }, status: :unprocessable_entity if seat_ids.empty?
    return render json: { error: "Amount missing" }, status: :unprocessable_entity unless amount.present?

    # Prevent duplicate pending booking for same showtime & seats
    recent_booking = Booking.where(
      user_id: current_user.id,
      showtime_id: params[:showtime_id],
      status: "pending"
    ).where("created_at >= ?", 1.minute.ago).first

    if recent_booking
      return render json: { error: "You already have a pending payment. Try again after a minute." }, status: :too_many_requests
    end

    # Generate PayU hash
    hash_string = "#{key}|#{txnid}|#{amount}|#{productinfo}|#{firstname}|#{email}|||||||||||#{salt}"
    hash = Digest::SHA512.hexdigest(hash_string)

    # Save booking as pending
    booking = Booking.create!(
      user_id: current_user.id,
      showtime_id: params[:showtime_id],
      seat_ids: seat_ids,  # JSON array
      txnid: txnid,
      status: "pending",
      amount: amount
    )

    render json: {
      key: key,
      txnid: txnid,
      hash: hash,
      amount: amount,
      firstname: firstname,
      email: email,
      phone: phone,
      productinfo: productinfo,
      surl: "#{request.base_url}/payments/success",
      furl: "#{request.base_url}/payments/failure",
      action: "https://test.payu.in/_payment"
    }
  rescue => e
    Rails.logger.error("Payment initiation error: #{e.message}")
    render json: { error: "Payment initiation failed" }, status: :internal_server_error
  end
  def success
    txnid = params[:txnid]
    status = params[:status]

    booking = Booking.find_by(txnid: txnid)
    if booking && status == "success"
      booking.update(status: "success")
      booking.seat_ids.each { |id| Seat.find_by(id: id)&.update(available: false) }
      render plain: "Payment successful!"
    else
      render plain: "Payment success callback received but booking not found."
    end
  end

  def failure
    txnid = params[:txnid]
    booking = Booking.find_by(txnid: txnid)
    booking.update(status: "failed") if booking
    render plain: "Payment failed!"
  end
end
