class User < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :approved

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true,length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}

  has_one :plan
  has_many :subscriptions, :foreign_key => :follower_id
  has_many :followed_users, :through => :subscriptions, :source => :followed_user

  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super
    end 
  end

  def subscribed?(followed_user_id)
    !Subscription.where(:follower_id => self.id, :followed_user_id => followed_user_id).blank?
  end

  def unread_subscriptions
    self.subscriptions.select do |subscription|
      subscription.read_time < subscription.followed_user.plan.updated_at
    end
  end

  def self.search(params)
    if params[:query] && params[:query].length > 0
    s = Tire.search 'users' do
      query do
        string "content:#{params[:query]}"
      end

      filter :terms, :username => [params[:username]] if params[:username]
      filter :terms, :email => [params[:email]] if params[:email]
    end
    s.results
    end
  end
end
