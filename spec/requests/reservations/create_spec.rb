require 'rails_helper'

RSpec.describe "POST /reservations", type: :request do
  subject(:perform_request) { post '/reservations', params: payload, as: :json }

  context 'when the payload is NOT valid' do
    let(:payload) do
      {
        invalid: 'payload'
      }
    end

    it "returns a bad request status" do
      perform_request

      expect(response).to have_http_status(:bad_request)
      expect(Reservations::PayloadProcessorJob).not_to have_enqueued_sidekiq_job
    end
  end

  context "when payload is from AirBnb" do
    let(:payload) do
      {
        reservation_code: "YYY12345678",
        start_date: "2021-04-14",
        end_date: "2021-04-18",
        nights: 4,
        guests: 4,
        adults: 2,
        children: 2,
        infants: 0,
        status: "accepted",
        currency: "AUD",
        payout_price: "4200.00",
        security_price: "500",
        total_price: "4700.00",
        guest: {
          first_name: "Wayne",
          last_name: "Woodbridge",
          phone: "639123456789",
          email: "wayne_woodbridge@bnb.com"
        }
      }
    end

    it "returns no content status" do
      perform_request

      expect(response).to have_http_status(:no_content)
      expect(Reservations::PayloadProcessorJob).to have_enqueued_sidekiq_job(payload.to_json)
    end
  end

  context "when payload is from Booking.com" do
    let(:payload) do
      {
        reservation: {
          code: "XXX12345678",
          start_date: "2021-03-12",
          end_date: "2021-03-16",
          expected_payout_amount: "3800.00",
          guest_details: {
            localized_description: "4 guests",
            number_of_adults: 2,
            number_of_children: 2,
            number_of_infants: 0
          },
          guest_email: "wayne_woodbridge@bnb.com",
          guest_first_name: "Wayne",
          guest_last_name: "Woodbridge",
          guest_phone_numbers: [
            "639123456789",
            "639123456789"
          ],
          listing_security_price_accurate: "500.00",
          host_currency: "AUD",
          nights: 4,
          number_of_guests: 4,
          status_type: "accepted",
          total_paid_amount_accurate: "4300.00"
        }
      }
    end

    it "returns no content status" do
      perform_request

      expect(response).to have_http_status(:no_content)
      expect(Reservations::PayloadProcessorJob).to have_enqueued_sidekiq_job(payload[:reservation].to_json)
    end
  end
end
