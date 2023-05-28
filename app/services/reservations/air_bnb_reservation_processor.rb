module Reservations
  class AirBnbReservationProcessorError < StandardError; end

  class AirBnbReservationProcessor
    VALID_PARAMS = %w[
      reservation_code
      start_date
      end_date
      nights
      guests
      adults
      children
      infants
      status
      guest
      currency
      payout_price
      security_price
      total_price
    ]

    SPECIAL_ATTRS = %w[
      reservation_code
      guest
    ]

    RESERVATION_ATTRS = VALID_PARAMS - SPECIAL_ATTRS

    def initialize(params)
      @params = params
    end

    def run
      raise Reservations::AirBnbReservationProcessorError.new('A valid payload is required') unless valid_params?

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
      @reservation ||= Reservation.find_or_initialize_by(code: reservation_code)
    end

    def reservation_params
      params.slice(*RESERVATION_ATTRS)
    end
  end
end
