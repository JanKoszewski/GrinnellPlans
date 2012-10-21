class AddPriorityToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :priority, :integer
    add_index  :subscriptions, :user_id
  end
end
