module Reservations
  class PayloadProcessorError < StandardError; end

  class PayloadProcessor
    def initialize(params)
      @params = params || {}
    end

    def run
      raise Reservations::PayloadProcessorError.new('A valid payload is required') if parsed_params.blank?

      return Reservations::AirBnbReservationProcessor.new(parsed_params).run if airbnb_params?

      Reservations::BookingReservationProcessor.new(parsed_params).run
    end

    private

    attr_reader :params

    def airbnb_params?
      parsed_params[:reservation_code].present?
    end

    def parsed_params
      @parsed_params ||= JSON.parse(params).with_indifferent_access
    end
  end
end
