class Option < ApplicationRecord
  belongs_to :debate
  has_many :votes, dependent: :destroy
  has_many :vetos, dependent: :destroy
  
  validates :text, presence: true, length: { minimum: 1, maximum: 200 }
  validates :position, presence: true
  validate :max_options_per_debate
  
  before_validation :set_position, on: :create
  
  scope :not_vetoed, -> { where(vetoed: false) }
  scope :by_position, -> { order(:position) }
  
  def veto!
    update!(vetoed: true)
  end
  
  def increment_vote_count!
    increment!(:vote_count)
  end
  
  def decrement_vote_count!
    decrement!(:vote_count)
  end
  
  private
  
  def set_position
    return if position.present?
    
    max_position = debate.options.maximum(:position) || 0
    self.position = max_position + 1
  end
  
  def max_options_per_debate
    return unless debate
    
    if debate.options.count >= 10
      errors.add(:base, "Cannot have more than 10 options per debate")
    end
  end
end
