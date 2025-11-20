FactoryBot.define do
  factory :win_streak do
    user { nil }
    current_streak { 1 }
    last_win_debate_id { 1 }
    last_decision_debate_id { 1 }
  end
end
