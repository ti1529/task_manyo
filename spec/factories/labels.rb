FactoryBot.define do
  factory :label do
    name { "label_1" }

    association :user
  end
end
