class ReservationsController < ApplicationController
  RESERVATION_PARAMS = %i[
    reservation_code
    start_date
    end_date
    nights
    guests
    adults
    children
    infants
    status
    currency
    payout_price
    security_price
    total_price
  ]

  GUEST_PARAMS = %i[
    first_name
    last_name
    phone
    email
  ]

  def create
    return render json: { error: 'Valid reservation params are required' }, status: :bad_request if reservation_params.blank?

    Reservations::PayloadProcessorJob.perform_async(reservation_params.to_json)

    head :no_content
  end

  private

  def reservation_params
    params[:reservation_code].present? ? params.permit(RESERVATION_PARAMS, guest: GUEST_PARAMS) : params.require(:reservation)
  end
end
