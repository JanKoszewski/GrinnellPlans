class Plan < ActiveRecord::Base
  before_save :add_permalink
  before_save :clean_text

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

  def clean_text
    links = []
    scan_for_matches.each do |result|
      links << find_link(result)
    end
    links
  end

  def scan_for_matches
    self.body.scan(/.*?\[(.*?)\].*?/s)
  end

  def find_link(result)
    potential_pair = result.first.scan(/^(.+)[|](.+)$/).first

    if potential_pair
      URI.extract(potential_pair.first, ['http', 'https']).first
    else
      result.first
    end
  end

  # def clean_text
  #   renderer = Redcarpet::Render::HTML.new :hard_wrap => true, :no_images => true
  #   markdown = Redcarpet::Markdown.new(
  #     renderer,
  #     :no_intra_emphasis => true,
  #     :strikethrough => true,
  #     :lax_html_blocks => true,
  #     :space_after_headers => true
  #   )
  #   plan = markdown.render self.body

  #   # Convert some legacy elements
  #   { :u => :underline, :strike => :strike, :s => :strike }.each do |in_class,out_class|
  #     pattern = Regexp.new "<#{in_class}>(.*?)<\/#{in_class}>"
  #     replacement = "<span class=\"#{out_class}\">\\1</span>"
  #     plan.gsub! pattern, replacement
  #   end

  #   # Now sanitize any bad elements
  #   self.body = Sanitize.clean plan, {
  #     :elements => %w[ a b hr i p span pre tt code br ],
  #     :attributes => {
  #       'a' => [ 'href' ],
  #       'span' => [ 'class' ],
  #     },
  #     :protocols => {
  #       'a' => { 'href' => [ 'http', 'https', 'mailto' ] }
  #     },
  #   }
  # end

  #   # TODO make actual rails links
  #    checked = {}
  #    loves = self.body.scan(/.*?\[(.*?)\].*?/s)#get an array of everything in brackets
  #   logger.debug("self.plan________"+self.body)
  #    for love in loves
  #      item = love.first
  #      jlw = item.gsub(/\#/, "\/")
  #      unless checked[item]
  #        user = User.where(:username=>item).first
  #        if user.blank?
  #          # if item.match(/^\d+$/) && SubBoard.find(:first, :conditions=>{:messageid=>item})
  #          #   #TODO  Regexp.escape(item, "/")
  #          #   self.body.gsub!(/\[" . Regexp.escape(item) . "\]/s, "[<a href=\"board_messages.php?messagenum=$item#{item}\" class=\"boardlink\">#{item}</a>]")
  #          # end
  #          if item =~ /:/
  #            if item =~ /|/
  #              love_replace = item.match(/(.+?)\|(.+)/si)
  #               self.body.gsub!(/\[" . Regexp.escape(item) . "\]/s, "<a href=\"/read/#{love_replace[1]}\" class=\"onplan\">#{love_replace[2]}</a>") #change all occurences of person on plan
  #            else
  #              self.body.gsub!(/\[" .  Regexp.escape(item) . "\]/s, "<a href=\"#{item}\" class=\"onplan\">#{item}</a>")
  #            end
  #          end
  #        else
  #          self.body.gsub!(/\[#{item}\]/s, "[<a href=\"/read/#{item}\" class=\"planlove\">#{item}</a>]"); #change all occurences of person on plan
  #        end
  #      end
  #      checked[item]=true
  #    end
  #    logger.debug("self.plan________"+self.body)
  # end

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
