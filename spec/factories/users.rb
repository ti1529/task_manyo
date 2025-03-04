FactoryBot.define do
  factory :user do
    name { "user_1" }
    email { "1@mail.com" }
    password { "password" }
    password_confirmation { "password" }

  end

  factory :admin, class: User do
    name { "admin_1" }
    email { "admin1@mail.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end

end