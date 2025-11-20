class DictatorToken < ApplicationRecord
  belongs_to :user
  belongs_to :used_in_debate, class_name: 'Debate', foreign_key: 'used_in_debate_id', optional: true
  
  validates :earned_at, presence: true
  validate :can_only_use_in_quick_decision_mode
  validate :cannot_use_on_consecutive_debates
  
  before_validation :set_earned_at, on: :create
  
  scope :unused, -> { where(used_at: nil) }
  scope :used, -> { where.not(used_at: nil) }
  
  def use!(debate)
    raise "Token already used" if used?
    raise "Can only use in quick decision mode" unless debate.quick_decision?
    
    if cannot_use_consecutively?(debate)
      raise "Cannot use dictator token on consecutive debates"
    end
    
    update!(
      used_at: Time.current,
      used_in_debate_id: debate.id
    )
  end
  
  def used?
    used_at.present?
  end
  
  def unused?
    used_at.nil?
  end
  
  private
  
  def set_earned_at
    self.earned_at ||= Time.current
  end
  
  def can_only_use_in_quick_decision_mode
    return unless used_in_debate_id && used_at
    
    debate = Debate.find_by(id: used_in_debate_id)
    if debate && !debate.quick_decision?
      errors.add(:base, "Can only use dictator tokens in quick decision mode")
    end
  end
  
  def cannot_use_on_consecutive_debates
    return unless user && used_in_debate_id
    
    if cannot_use_consecutively?(Debate.find(used_in_debate_id))
      errors.add(:base, "Cannot use dictator token on consecutive debates")
    end
  end
  
  def cannot_use_consecutively?(debate)
    last_used_token = user.dictator_tokens
                          .used
                          .where.not(id: id)
                          .order(used_at: :desc)
                          .first
    
    return false unless last_used_token
    
    last_used_debate_id = last_used_token.used_in_debate_id
    
    debates_between = user.created_debates
                          .where('created_at > ?', last_used_token.used_at)
                          .where('created_at < ?', debate.created_at)
                          .count
    
    debates_between == 0
  end
end
