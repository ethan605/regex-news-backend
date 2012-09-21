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
    update_time: { definition: :update_time_rfc },
    title: { },
    url: { },
    tops: { definition: :top_news },
    contents: { definition: :content_news }

  def update_category(name, attributes)
    category = Category.find_or_initialize_by(url: attributes[:url])
    category.update_attributes!(attributes)
    self.send("update_#{name}", category)
    return category
  end

  def update_top(category)
    self.tops << category
    self.save!
  end

  def update_content(category)
    self.contents << category
    self.save!
  end

  def update_time_rfc
    return self.update_time.rfc822
  end

  def top_news
    return tops.as_json
  end

  def content_news
    return contents.as_json
  end

  private :update_top, :update_content, :update_time_rfc, :top_news, :content_news
end
