class Category
  include Mongoid::Document
  include Mongoid::CachedJson

  field :url
  field :title

  has_many :mains, class_name: 'Article', inverse_of: :main
  has_many :subs, class_name: 'Article', inverse_of: :sub
  has_many :others, class_name: 'Article', inverse_of: :other

  belongs_to :top, class_name: 'Site', inverse_of: :tops
  belongs_to :content, class_name: 'Site', inverse_of: :contents

  json_fields \
    url: { },
    title: { },
    mains: { definition: :main_news },
    subs: { definition: :sub_news },
    others: { definition: :other_news }

  def main_news
    return main.as_json
  end

  def sub_news
    return sub.as_json
  end

  def other_news
    return other.as_json
  end
end
