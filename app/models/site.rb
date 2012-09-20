class Site
  include Mongoid::Document
  include Mongoid::CachedJson

  field :update_time, type: DateTime, default: ->{ DateTime.now }
  field :url
  field :title
  
  has_many :tops, class_name: 'Category', inverse_of: :top
  has_many :contents, class_name: 'Category', inverse_of: :content

  validates_presence_of :url, :title
  validates_uniqueness_of :update_time

  json_fields \
    update_time: { },
    title: { },
    url: { },
    tops: { definition: :top_news },
    contents: { definition: :content_news }

  def self.init
    Article.delete_all
    Category.delete_all
    Site.delete_all
    9.times do |i|
      a = Article.new(url: "url ##{i}", title: "title ##{i}")
      a.save
    end
    (0..2).each do |i|
      c = Category.new
      c.save
      c.mains << Article.all.at(i*3)
      c.subs << Article.all.at(i*3+1)
      c.contents << Article.all.at(i*3+2)
      c.save
    end
    s = Site.new
    s.save
    s.tops << Category.all.at(0)
    s.contents << Category.all.at(1)
    s.contents << Category.all.at(2)
    s.save
  end
end
