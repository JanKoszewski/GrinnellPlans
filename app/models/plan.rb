class Plan < ActiveRecord::Base

  before_save :add_permalink

	include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :title, :body, :permalink
  attr_accessor :html

  belongs_to :user

  def to_param
    permalink
  end

  def add_permalink
    self.permalink = self.user.username
  end

  def scan_for_matches(text)
    matches = text.scan(/.*?\[(.*?)\].*?/s)
    matches.uniq.delete_if { |result| result.first.blank? }
  end

  def find_link(result)
    potential_pair = result.first.scan(/^(.+)[|](.+)$/).first

    if potential_pair
      {uri: URI.extract(potential_pair.first, ['http', 'https']).first, text: potential_pair.last }
    else
      {plan: result.first }
    end
  end

  def create_link(result)
    hash = find_link(result)
    hash.keys.first == :uri ? external_link(hash) : plan_link(hash)
  end

  def external_link(hash={})
    "<a href=#{hash[:uri]}>#{hash[:text]}</a>"
  end

  def plan_link(hash={})
    "[<a href=#{Rails.root.to_s}/plans/#{hash[:plan]}>#{hash[:plan]}</a>]"
  end

  def replace_links(text)
    scan_for_matches(text).each do |result|
      text.gsub!(Regexp.new(Regexp.escape("["+result.first+"]")), create_link(result))
    end
    text
  end

  def replace_line_breaks(text)
    text.gsub!(/\r\n|\r|\n/, "<br>")
  end

  def html
    text = self.body
    replace_links(text)
    replace_line_breaks(text)
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
