class AddHtmlToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :html, :text, :default => ""
  end
end
