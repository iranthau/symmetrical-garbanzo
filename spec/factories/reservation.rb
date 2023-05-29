FactoryBot.define do
  factory :reservation do
    code { FFaker::NatoAlphabet.alphabetic_code }

    association :guest, factory: :guest
  end
end
