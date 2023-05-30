require 'rails_helper'

RSpec.describe Reservations::AirBnbReservationProcessor, type: :service do
  subject(:processor) { described_class.new(params.with_indifferent_access) }

  let(:params) do
    {
      invalid_param: 'invalid value'
    }
  end

  describe '#run' do
    subject(:run) { processor.run }

    context 'when the given params are NOT valid' do
      it 'raises an error' do
        expect { run }.to raise_error(Reservations::AirBnbReservationProcessorError, 'A valid payload is required')
      end
    end

    context 'when the given params are valid' do
      let(:params) do
        {
          reservation_code: reservation_code,
          start_date: '2021-04-14',
          end_date: '2021-04-18',
          nights: 4,
          guests: 4,
          adults: 2,
          children: 2,
          infants: 0,
          status: 'accepted',
          guest: {
            first_name: 'Wayne',
            last_name: 'Woodbridge',
            phone: '639123456789',
            email: guest_email
          },
          currency: 'AUD',
          payout_price: '4200.00',
          security_price: '500',
          total_price: '4700.00'
        }
      end
      let(:guest_email) { 'wayne_woodbridge@bnb.com' }
      let(:reservation_code) { 'YYY12345678' }

      context 'but incorrect guest params are given' do
        let(:guest_email) { nil }

        it 'raises an error' do
          expect { run }.to raise_error(ActiveRecord::RecordInvalid)

          expect(Guest.count).to eq(0)
          expect(Reservation.count).to eq(0)
        end
      end

      context 'and the guest params are valid' do
        context 'but the reservation params are invalid' do
          let(:reservation_code) { nil }

          it 'raises an error' do
            expect { run }.to raise_error(ActiveRecord::RecordInvalid)
            expect(Guest.count).to eq(1)
            expect(Reservation.count).to eq(0)

            expect(Guest.last).to have_attributes(
              first_name: 'Wayne',
              last_name: 'Woodbridge',
              phone_numbers: ['639123456789'],
              email: guest_email
            )
          end
        end

        context 'and the reservation params are valid' do
          it 'saves the guest and the reservation' do
            expect { run }.to(change { Reservation.count }.by(1))
            expect(Guest.count).to eq(1)

            expect(Reservation.last).to have_attributes(
              code: reservation_code,
              start_date: Date.parse('2021-04-14'),
              end_date: Date.parse('2021-04-18'),
              nights: 4,
              guests: 4,
              adults: 2,
              children: 2,
              infants: 0,
              status: 'accepted',
              currency: 'AUD',
              payout_price: 4200.00,
              security_price: 500.00,
              total_price: 4700.00
            )
            expect(Guest.last).to have_attributes(
              first_name: 'Wayne',
              last_name: 'Woodbridge',
              phone_numbers: ['639123456789'],
              email: guest_email
            )
          end
        end
      end
    end
  end
end
