require 'rails_helper'

RSpec.describe Reservations::PayloadProcessor, type: :service do
  subject(:processor) { described_class.new(params.to_json) }

  describe '#run' do
    subject(:run) { processor.run }

    context 'when the params are empty' do
      let(:params) { {} }

      it 'raises an error' do
        expect { run }.to raise_error(Reservations::PayloadProcessorError, 'A valid payload is required')
      end
    end

    context 'when the params contain the key reservation' do
      let(:params) do
        {
          reservation: {
            code: "XXX12345678",
            start_date: "2021-03-12",
            end_date: "2021-03-16",
            expected_payout_amount: "3800.00"
          }
        }
      end
      let(:booking_processor) { instance_double(Reservations::BookingReservationProcessor, run: nil) }

      before do
        allow(Reservations::BookingReservationProcessor).to receive(:new).with(params[:reservation]).and_return(booking_processor)
      end

      it 'runs the BookingReservationProcessor' do
        run

        expect(booking_processor).to have_received(:run)
      end
    end

    context 'when the params do not contain the key reservation' do
      let(:params) do
        {
          reservation_code: "YYY12345678",
          start_date: "2021-04-14",
          end_date: "2021-04-18",
          nights: 4
        }
      end

      let(:airbnb_processor) { instance_double(Reservations::AirBnbReservationProcessor, run: nil) }

      before do
        allow(Reservations::AirBnbReservationProcessor).to receive(:new).with(params).and_return(airbnb_processor)
      end

      it 'runs the AirBnbReservationProcessor' do
        run

        expect(airbnb_processor).to have_received(:run)
      end
    end
  end
end
