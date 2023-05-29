require 'rails_helper'

RSpec.describe Reservations::PayloadProcessorJob, type: :job do
  subject(:job) { described_class.new }

  describe '#perform' do
    subject(:perform_job) { job.perform(payload) }

    let(:payload) { {} }

    context 'when the payload is empty' do
      it 'raises an ArgumentError' do
        expect { perform_job }.to raise_error(ArgumentError, 'Valid reservation params are required')
      end
    end

    context 'when the payload is NOT empty' do
      let(:payload) do
        {
          reservation_code: 'YYY12345678',
          start_date: '2021-04-14',
          end_date: '2021-04-18',
          nights: 4
        }
      end
      let(:processor_mock) { instance_double(Reservations::PayloadProcessor, run: nil) }

      before do
        allow(Reservations::PayloadProcessor).to receive(:new).with(payload).and_return(processor_mock)
      end

      it 'enqueues a job' do
        perform_job

        expect(processor_mock).to have_received(:run)
      end
    end
  end
end
