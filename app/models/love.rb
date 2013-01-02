class Love < ActiveRecord::Base
  attr_accessible :user_id, :love_id, :link_text
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :lover, :class_name => "User", :foreign_key => "love_id"

  validates_uniqueness_of :link_text
  # attr_accessible :title, :body
end
