class RemovePermalinkFromSubscriptions < ActiveRecord::Migration
	def change
		remove_column :subscriptions, :permalink, :string
  	add_column :plans, :permalink, :string
  end
end
