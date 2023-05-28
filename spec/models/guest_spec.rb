require 'rails_helper'

RSpec.describe Guest, type: :model do
  subject(:guest) { FactoryBot.create(:guest) }

  describe 'associations' do
    it { should have_many(:reservations).class_name('Reservation') }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
