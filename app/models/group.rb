class Group < ApplicationRecord

    belongs_to :creator, class_name: 'User'
    has_many :group_memberships, dependent: :destroy
    has_many :members, through: :group_memberships, source: :user
    has_many :debates, dependent: :destroy

    validates :name, presence: true
                     length: { minimum: 3, maximum: 50 }

    def add_member(user)
        members << user unless members.include?(user)
    end
    
    def remove_member(user)
        members << user unless members.include?(user)
    end
    
    def member?(user)
        members.include?(user)
    end
end
