class RenameSurroundTextToKeyInMention < ActiveRecord::Migration
  def up
    rename_column :mentions, :surround_text, :key
  end

  def down
    rename_column :mentions, :key, :surround_text
  end
end
