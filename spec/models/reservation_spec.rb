require 'rails_helper'

RSpec.describe Reservation, type: :model do
  subject(:reservation) { FactoryBot.create(:reservation) }

  describe 'associations' do
    it { should belong_to(:guest).class_name('Guest') }
  end

  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
  end
end
