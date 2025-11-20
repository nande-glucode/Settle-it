class WinStreak < ApplicationRecord
  belongs_to :user
  belongs_to :last_win_debate, class_name: 'Debate', foreign_key: 'last_win_debate_id', optional: true
  belongs_to :last_decision_debate, class_name: 'Debate', foreign_key: 'last_decision_debate_id', optional: true
  
  validates :current_streak, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: true
  
  def increment_streak!(debate, winning_option)
    user_vote = user.votes.find_by(debate: debate)
    
    if user_vote && user_vote.option_id == winning_option.id
      new_streak = current_streak + 1
      
      update!(
        current_streak: new_streak,
        last_win_debate_id: debate.id,
        last_decision_debate_id: debate.id
      )
      
      if new_streak == 3
        award_dictator_token!
        reset_streak!
      end
    else
      update!(
        current_streak: 0,
        last_decision_debate_id: debate.id
      )
    end
  end
  
  def reset_streak!
    update!(current_streak: 0)
  end
  
  def award_dictator_token!
    user.dictator_tokens.create!(earned_at: Time.current)
  end
  
  def can_use_dictator_token?(debate)
    last_used_token = user.dictator_tokens.used.order(used_at: :desc).first
    
    return true unless last_used_token
    
    last_used_token.used_in_debate_id != debate.id
  end
end
