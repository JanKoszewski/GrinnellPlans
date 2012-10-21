class Plan < ActiveRecord::Base
  after_create :create_lists
  
	include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :title, :body, :permalink
  belongs_to :user

  def to_param
    permalink
  end

  def create_lists
    3.times do |list|
      self.user.lists << List.new(:title => "Level #{list+1}")
      self.user.save!
    end
  end

  def self.search(params)
    if params[:query] && params[:query].length > 0
    s = Tire.search 'users' do
      query do
        string "content:#{params[:query]}"
      end

      filter :terms, :permalink => [params[:permalink]] if params[:permalink]
      filter :terms, :title => [params[:title]] if params[:title]
      filter :terms, :body => [params[:body]] if params[:body]
    end
    s.results
    end
  end
end
