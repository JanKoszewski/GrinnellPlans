class Mention < ActiveRecord::Base
  attr_accessible :mentioned_user_id, :mentioned_user, :surround_text
  belongs_to :mentioned, :class_name => "User", :foreign_key => "mentioned_id"
  belongs_to :mentioned_user, :class_name => "User", :foreign_key => "mentioned_user_id"

  # validates_uniqueness_of :mentioned_user_id, :scope => :mentioned_id

  def self.create_from_plan_link(result_array, user_id)
    self.new User.find_by_username(result_array[1])
  end
end
