class Site
  include Mongoid::Document
  include Mongoid::CachedJson

  field :update_time, type: DateTime, default: ->{ DateTime.now }
  field :url
  field :title
  
  has_many :categories

  validates_presence_of :url, :title
  validates_uniqueness_of :update_time

  json_fields \
    update_time: { definition: :update_time_rfc },
    title: { },
    url: { },
    categories: { definition: :categories_json }

  def self.crawl(domain)
    Rule::Crawler.crawl(domain)
  end

  def self.crawl_all
    Article.delete_all
    Category.delete_all
    Site.delete_all
    
    Rule::Crawler::SITE_RULES.each do |domain, properties|
      crawl(domain)
    end
  end

  def update_category(attributes)
    category = Category.find_or_initialize_by(url: attributes[:url])
    category.update_attributes!(attributes)
    self.categories << category
    self.save!
    return category
  end

  def update_time_rfc
    return self.update_time.rfc822
  end

  def categories_json
    return categories.as_json
  end

  private :update_time_rfc, :categories_json
end
