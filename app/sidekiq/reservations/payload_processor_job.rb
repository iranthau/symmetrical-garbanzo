module Reservations
  class PayloadProcessorJob
    include Sidekiq::Job

    def perform(reservation_params)
      raise ArgumentError, 'Valid reservation params are required' if reservation_params.blank?

      # Reservations::PayloadProcessor.new(reservation_params).run
    end
  end
end
