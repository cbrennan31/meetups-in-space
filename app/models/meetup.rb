class Meetup < ActiveRecord::Base
  has_many :registrations
  has_many :users,
  through: :registrations

  validates :name,
    uniqueness: { message: "There is already a meetup called \'%{value}.\'"},
    presence: { message: "Please specify a name."}
  validates :description, presence: { message: "Please include a description." }
  validates :location, presence: { message: "Please specify a location." }
end
