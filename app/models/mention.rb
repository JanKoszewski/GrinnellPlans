class Mention < ActiveRecord::Base
  attr_accessible :mentioned_user_id, :mentioned_user
  belongs_to :mentioned, :class_name => "User", :foreign_key => "mentioned_id"
  belongs_to :mentioned_user, :class_name => "User", :foreign_key => "mentioned_user_id"

  # validates_uniqueness_of :mentioned_user_id, :scope => :mentioned_id
end
