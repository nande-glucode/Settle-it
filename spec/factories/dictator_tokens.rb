FactoryBot.define do
  factory :dictator_token do
    user { nil }
    earned_at { "2025-10-29 12:11:28" }
    used_at { "2025-10-29 12:11:28" }
    used_in_debate_id { 1 }
  end
end
