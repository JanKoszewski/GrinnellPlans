class AddLinkTextToLove < ActiveRecord::Migration
  def change
    add_column :loves, :link_text, :string

    add_index :loves, :user_id
  end
end
