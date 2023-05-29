module Reservations
  class PayloadProcessorError < StandardError; end

  class PayloadProcessor
    def initialize(params)
      @params = params || {}
    end

    def run
      raise Reservations::PayloadProcessorError.new('A valid payload is required') if parsed_params.blank?

      return Reservations::BookingReservationProcessor.new(booking_reservation_params).run if booking_reservation_params.present?

      Reservations::AirBnbReservationProcessor.new(parsed_params).run
    end

    private

    attr_reader :params

    def booking_reservation_params
      @booking_reservation_params ||= parsed_params[:reservation]
    end

    def parsed_params
      @parsed_params ||= JSON.parse(params).with_indifferent_access
    end
  end
end
