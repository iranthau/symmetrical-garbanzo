FactoryBot.define do
  factory :guest do
    email { FFaker::Internet.email }
  end
end
