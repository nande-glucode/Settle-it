FactoryBot.define do
  factory :user do
    email { "MyString" }
    username { "MyString" }
    password_digest { "MyString" }
    vetos_remaining { 1 }
    vetos_reset_at { "2025-10-23 11:06:18" }
  end
end
