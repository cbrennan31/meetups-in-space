class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates :user_id, presence: true
  validates :meetup_id,
    presence: true,
    uniqueness: {
      scope: :user_id,
      message: "You\'ve already signed up for this meetup."
    }
end
