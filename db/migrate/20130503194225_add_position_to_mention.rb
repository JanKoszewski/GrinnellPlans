class AddPositionToMention < ActiveRecord::Migration
  def change
    add_column :mentions, :position, :integer
  end
end
