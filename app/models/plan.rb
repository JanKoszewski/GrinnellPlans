class Plan < ActiveRecord::Base
  before_save :add_permalink
  
	include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :title, :body, :permalink
  belongs_to :user

  def to_param
    permalink
  end

  def add_permalink
    self.permalink = self.user.username
  end

  def self.search(params)
    if params[:query] && params[:query].length > 0
    s = Tire.search 'users' do
      query do
        string "content:#{params[:query]}"
      end

      filter :terms, :title => [params[:title]] if params[:title]
      filter :terms, :body => [params[:body]] if params[:body]
    end
    s.results
    end
  end
end
