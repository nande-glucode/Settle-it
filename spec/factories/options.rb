FactoryBot.define do
  factory :option do
    debate { nil }
    text { "MyString" }
    vote_count { 1 }
    vetoed { false }
    position { 1 }
  end
end
