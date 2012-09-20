class Article
  include Mongoid::Document
  include Mongoid::CachedJson

  belongs_to :main, class_name: 'Category', inverse_of: :mains
  belongs_to :sub, class_name: 'Category', inverse_of: :subs
  belongs_to :other, class_name: 'Category', inverse_of: :subs

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
