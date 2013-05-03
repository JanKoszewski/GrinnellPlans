class AddPermalinkToPlans < ActiveRecord::Migration
  def change
  	add_column :plans, :permalink, :string
  end
end
