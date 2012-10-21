class AddPermalinkToPlans < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :permalink, :string
  end
end
