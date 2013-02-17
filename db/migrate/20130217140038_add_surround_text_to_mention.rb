class AddSurroundTextToMention < ActiveRecord::Migration
  def change
    add_column :mentions, :surround_text, :string
  end
end
