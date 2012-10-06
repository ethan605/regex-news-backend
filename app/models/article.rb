class Article
  include Mongoid::Document
  include Mongoid::CachedJson

  belongs_to :category

  validates_presence_of :url, :title
  validates_uniqueness_of :url

  field :url
  field :title
  field :image
  field :spoiler

  json_fields \
    url: { },
    title: { },
    image: { },
    spoiler: { }
end
