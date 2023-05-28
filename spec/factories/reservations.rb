FactoryBot.define do
  factory :reservation do
    code { FFaker::Code }

    association :guest, factory: :guest
  end
end
