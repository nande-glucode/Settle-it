class Debate < ApplicationRecord
  enum mode: { debate: 0, quick_decision: 1 }
  enum status: { pending: 0, acknowledged: 1, voting: 2, runoff: 3, completed: 4 }
  
  belongs_to :creator, class_name: 'User'
  belongs_to :group, optional: true
  belongs_to :parent_debate, class_name: 'Debate', optional: true
  belongs_to :winner_option, class_name: 'Option', optional: true
  
  has_one :runoff_debate, class_name: 'Debate', foreign_key: 'parent_debate_id', dependent: :destroy
  has_many :debate_participants, dependent: :destroy
  has_many :participants, through: :debate_participants, source: :user
  has_many :options, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :vetos, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :mode, presence: true
  validates :status, presence: true
  validate :dictator_mode_only_in_quick_decision
  
  scope :active, -> { where(status: [:pending, :acknowledged, :voting, :runoff]) }
  scope :completed, -> { where(status: :completed) }
  scope :for_group, ->(group_id) { where(group_id: group_id) }
  
  def start_voting!
    update!(
      status: :voting,
      voting_ends_at: 60.seconds.from_now
    )
  end
  
  def start_runoff!(tied_options)
    update!(
      status: :runoff,
      voting_ends_at: 30.seconds.from_now
    )
  end
  
  def complete!(winning_option)
    update!(
      status: :completed,
      winner_option: winning_option
    )
  end
  
  def all_acknowledged?
    debate_participants.where(acknowledged: false).none?
  end
  
  def is_runoff?
    parent_debate_id.present?
  end
  
  private
  
  def dictator_mode_only_in_quick_decision
  end
end
