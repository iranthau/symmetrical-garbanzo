module Reservations
  class AirBnbReservationProcessorError < StandardError; end

  class AirBnbReservationProcessor
    VALID_PARAMS = %w[
      adults
      children
      currency
      end_date
      guest
      guests
      infants
      nights
      payout_price
      reservation_code
      security_price
      start_date
      status
      total_price
    ]

    SPECIAL_ATTRS = %w[
      guest
      reservation_code
    ]

    RESERVATION_ATTRS = VALID_PARAMS - SPECIAL_ATTRS

    GUEST_ATTRS = %w[
      email
      first_name
      last_name
      phone
    ]

    def initialize(params)
      @params = params
    end

    def run
      raise Reservations::AirBnbReservationProcessorError.new('A valid payload is required') unless valid_params?

      guest.save!
      reservation.update!(reservation_params)
    end

    private

    attr_reader :params

    def valid_params?
      params.keys.all? { |key| VALID_PARAMS.include?(key) }
    end

    def reservation_code
      params[:reservation_code]
    end

    def reservation
      @reservation ||= guest.reservations.find_or_initialize_by(code: reservation_code)
    end

    def reservation_params
      params.slice(*RESERVATION_ATTRS)
    end

    def guest_params
      params[:guest].slice(*GUEST_ATTRS)
    end

    def guest_email
      guest_params[:email]
    end

    def guest
      @guest ||= Guest.find_or_initialize_by(email: guest_email) do |g|
        g.first_name = guest_params[:first_name]
        g.last_name = guest_params[:last_name]
        g.phone_numbers << guest_params[:phone]
      end
    end
  end
end
