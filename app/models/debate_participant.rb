class DebateParticipant < ApplicationRecord
  belongs_to :debate
  belongs_to :user
  
  validates :user_id, uniqueness: { scope: :debate_id, message: "is already a participant" }
  
  before_validation :set_invited_at, on: :create
  
  def acknowledge!
    update!(acknowledged: true)
  end
  
  private
  
  def set_invited_at
    self.invited_at ||= Time.current
  end
end
