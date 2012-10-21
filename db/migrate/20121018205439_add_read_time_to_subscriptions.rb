class AddReadTimeToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :read_time, :datetime
  end
end
