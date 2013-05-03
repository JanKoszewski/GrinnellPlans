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
      { nonlink: result.first }
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
      non_link(hash)
    end
  end

  def external_link(hash={})
    "<a href=#{hash[:uri]}>#{hash[:text]}</a>"
  end

  def plan_link(hash={})
    "[<a href='/plans/#{hash[:plan]}'>#{hash[:plan]}</a>]"
  end

  def non_link(hash={})
    "[#{hash[:nonlink]}]"
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

  def remove_possible_javascript(text)
    possible_javascript = text.scan(/.*script.*/s)
    if possible_javascript.present?
      possible_javascript.each { |pj| text.slice!(pj) }
    end
    text
  end

  def html
    if self.body.present?
      text = self.body
      remove_possible_javascript(text)
      replace_links(text)
      replace_line_breaks(text)
    else
      ""
    end
  end

  def create_mention(result)
    if u = User.find_by_username(result)
      keys = self.body.scan(/(.{6})?\[(#{result.first})\](.{6})?/)
      keys.each do |key|
        unless Mention.where(mentioned_user_id: self.user.id, surround_text: key.join).present?
          u.mentions.create(mentioned_user_id: self.user.id, surround_text: key.join  )
        end
      end
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
