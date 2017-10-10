class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :user_id, null: false
      t.integer :meetup_id, null: false

      t.timestamps null: false
    end
  end
end
