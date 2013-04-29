class Mention < ActiveRecord::Base
  attr_accessible :mentioned_user_id, :mentioned_id, :surround_text
  belongs_to :mentioned, :class_name => "User", :foreign_key => "mentioned_id"
  belongs_to :mentioned_user, :class_name => "User", :foreign_key => "mentioned_user_id"

  validates_uniqueness_of :surround_text, :scope => :mentioned_id

#NEED CUSTOM SCOPES ON WHEN A USER HAS VIEWED/CLICKED



#IDEA FOR UNIQUENESS:
  #SAVE PLAN LENGTH AS ATTRIBUTE ON PLAN ON SAVE
  #CHECK RELATIVE POSITION OF MENTION AS A DIFFERENCE OF PREVIOUS PLAN LENGTH BEFORE AND AFTER SAVE
  #WORKS FOR EXPADNING PLANS, NOT NECESSARILY FOR DELETION (IF PLAN GETS SHORTER)
  #QUESTIONS:
    #HOW DO YOU DEFINE POSITION? BEGINNING OF KEY/SURROUND TEXT?

end
