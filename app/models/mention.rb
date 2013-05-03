class Mention < ActiveRecord::Base
  attr_accessible :mentioned_user_id, :mentioned_id, :key, :read_time, :position
  belongs_to :mentioned, :class_name => "User", :foreign_key => "mentioned_id"
  belongs_to :mentioned_user, :class_name => "User", :foreign_key => "mentioned_user_id"

  validates_uniqueness_of :key, :scope => :mentioned_id

  def self.mark_plan_as_read(mentioned_id, mentioned_user_id)
    if mentions = Mention.where(:mentioned_id => mentioned_id, :mentioned_user_id => mentioned_user_id)
      mentions.each do |mention|
        mention.read_time = Time.now
        mention.save!
      end
    end
  end

  def unread
    self.read_time.nil?
  end

  def check_position(text)

  end
end
