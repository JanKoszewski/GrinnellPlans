class AddLengthChangeToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :previous_length, :integer
    add_column :plans, :change_in_length, :integer
  end
end
