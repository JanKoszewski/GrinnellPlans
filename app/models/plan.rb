class Plan < ActiveRecord::Base

  before_save :add_permalink
  # after_save :replace_date_markup

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

  def scan_for_matches(text)
    matches = text.scan(/.*?\[(.*?)\].*?/s)
    matches.delete_if { |result| result.first.blank? }
  end

  def unique_matches(text)
    scan_for_matches(text).uniq
  end

  def find_link(result)
    potential_pair = result.first.scan(/^(.+)[|](.+)$/).first

    if potential_pair
      { uri: URI.extract(potential_pair.first, ['http', 'https']).first, text: potential_pair.last }
    elsif Plan.find_by_permalink(result.first)
      create_mention(result)
      { plan: result.first }
    else
      { plan: result.first }
      # { nonlink: result.first } NEED TO DECIDE WHAT TO DO WITH THESE
    end
  end

  def create_link(result)
    hash = find_link(result)

    case hash.keys.first
    when :uri
      external_link(hash)
    when :plan
      plan_link(hash)
    else
      plan_link(hash)
    end
  end

  def external_link(hash={})
    "<a href=#{hash[:uri]}>#{hash[:text]}</a>"
  end

  def plan_link(hash={})
    "[<a href='/plans/#{hash[:plan]}'>#{hash[:plan]}</a>]"
  end

  def replace_links(text)
    unique_matches(text).each do |result|
      text.gsub!(Regexp.new(Regexp.escape("["+result.first+"]")), create_link(result))
    end
    text
  end

  def replace_line_breaks(text)
    text.gsub!(/\r\n|\r|\n/, "<br>")
    text
  end

  def replace_date_markup
    self.body.gsub!(/.*?\[date\].*?/s, "<b>#{Time.now.to_s}</b>")
    puts "I replaced a date!"
  end

  def html
    if self.body.present?
      text = self.body
      replace_links(text)
      replace_line_breaks(text)
    else
      ""
    end
  end

  def create_mention(result)
    key = self.body.scan(/(.{6})?\[(#{result.first})\](.{6})?/).join
    u = User.find_by_username(result)

    unless Mention.find_by_mentioned_user_id_and_surround_text(self.user.id, key) && u.present?
      u.mentions.create(mentioned_user_id: self.user.id, surround_text: key)
    end
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
