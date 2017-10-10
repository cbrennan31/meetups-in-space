class AddIndexToRegistrations < ActiveRecord::Migration
  def change
    add_index :registrations, [:meetup_id, :user_id], unique: true
  end
end
