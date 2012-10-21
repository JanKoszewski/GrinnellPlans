class Subscription < ActiveRecord::Base
  attr_accessible :followed_user_id, :followed_user, :priority
  belongs_to :follower, :class_name => "User", :foreign_key => "follower_id"
  belongs_to :followed_user, :class_name => "User", :foreign_key => "followed_user_id"

  validate :subscription_to_other_user
  validates_uniqueness_of :followed_user_id, :scope => :follower_id

  def self.mark_plan_as_read(follower_id, followed_user_id)
    if (subscription = Subscription.where(:follower_id => follower_id, :followed_user_id => followed_user_id).first)
      subscription.read_time = Time.now
      subscription.save!
    end
  end

private
  def subscription_to_other_user
    if followed_user_id == follower_id
      errors.add(:followed_user_id, "You can't subscribe to yourself")
    end
  end
end
