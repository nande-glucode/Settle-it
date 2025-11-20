class Vote < ApplicationRecord
  belongs_to :debate
  belongs_to :option
  belongs_to :user
  
  validates :user_id, uniqueness: { scope: :debate_id, message: "has already voted in this debate" }
  validate :option_belongs_to_debate
  validate :option_not_vetoed
  
  after_create :increment_option_vote_count
  after_destroy :decrement_option_vote_count
  before_update :update_vote_counts, if: :option_id_changed?
  
  private
  
  def increment_option_vote_count
    option.increment_vote_count!
  end
  
  def decrement_option_vote_count
    option.decrement_vote_count!
  end
  
  def update_vote_counts
    old_option = Option.find(option_id_was)
    old_option.decrement_vote_count!
    option.increment_vote_count!
  end
  
  def option_belongs_to_debate
    return unless option && debate
    
    unless option.debate_id == debate_id
      errors.add(:option, "must belong to the debate")
    end
  end
  
  def option_not_vetoed
    return unless option
    
    if option.vetoed?
      errors.add(:option, "has been vetoed and cannot be voted for")
    end
  end
end
