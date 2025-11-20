FactoryBot.define do
  factory :debate do
    title { "MyString" }
    mode { 1 }
    creator_id { 1 }
    group_id { 1 }
    status { 1 }
    voting_ends_at { "2025-10-23 11:51:20" }
    winner_option_id { 1 }
    parent_debate_id { 1 }
    creator_votes { false }
  end
end
