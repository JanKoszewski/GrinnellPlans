class AddReadTimeToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :read_time, :datetime
  end
end
