class AddFollowedUserIdAndRemoveUserIdFromSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :followed_user_id, :integer
    add_index  :subscriptions, :followed_user_id

    remove_column :subscriptions, :user_id
  end
end
