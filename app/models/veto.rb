class Veto < ApplicationRecord
  belongs_to :debate
  belongs_to :option
  belongs_to :user
  
  validate :user_has_vetos_remaining
  validate :option_belongs_to_debate
  validate :cannot_veto_same_option_twice
  
  after_create :apply_veto_effects
  
  private
  
  def apply_veto_effects
    option.veto!
    
    user.use_veto!
  end
  
  def user_has_vetos_remaining
    return unless user
    
    if user.vetos_remaining <= 0
      errors.add(:base, "No vetos remaining")
    end
  end
  
  def option_belongs_to_debate
    return unless option && debate
    
    unless option.debate_id == debate_id
      errors.add(:option, "must belong to the debate")
    end
  end
  
  def cannot_veto_same_option_twice
    return unless user && option && debate
    
    if Veto.exists?(debate: debate, option: option, user: user)
      errors.add(:base, "Already vetoed this option")
    end
  end
end
