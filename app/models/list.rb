class List < ActiveRecord::Base
  attr_accessible :title

  belongs_to :user
  has_many :subscriptions

  def to_param
    permalink
  end
end
