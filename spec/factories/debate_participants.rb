FactoryBot.define do
  factory :debate_participant do
    debate { nil }
    user { nil }
    acknowledged { false }
    invited_at { "2025-10-23 11:53:23" }
  end
end
