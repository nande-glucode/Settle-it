class User < ApplicationRecord
  has_secure_password

  has_many :created_groups, class_name: 'Group', foreign_key: 'creator_id', dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :created_debates, class_name: 'Debate', foreign_key: 'creator_id', dependent: :destroy
  has_many :debate_participants, dependent: :destroy
  has_many :debates, through: :debate_participants
  has_many :votes, dependent: :destroy
  has_many :vetos, dependent: :destroy
  has_many :dictator_tokens, dependent: :destroy
  has_one :win_streak, dependent: :destroy
  
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 20 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }
  
  validates :vetos_remaining, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  
  before_create :set_veto_reset_date
  after_create :create_win_streak
  
  def use_veto!
    return false if vetos_remaining <= 0
    
    update!(vetos_remaining: vetos_remaining - 1)
  end
  
  def reset_vetos_if_needed
    return unless vetos_reset_at && Time.current >= vetos_reset_at
    
    update!(
      vetos_remaining: 3,
      vetos_reset_at: 1.month.from_now
    )
  end
  
  def unused_dictator_tokens_count
    dictator_tokens.unused.count
  end
  
  def can_use_dictator_token?(debate)
    return false if unused_dictator_tokens_count == 0
    return false unless debate.quick_decision?
    
    win_streak&.can_use_dictator_token?(debate)
  end
  
  private
  
  def set_veto_reset_date
    self.vetos_reset_at = 1.month.from_now
  end
  
  def create_win_streak
    WinStreak.create!(user: self)
  end
end