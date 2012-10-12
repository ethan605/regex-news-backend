class Category
  include Mongoid::Document
  include Mongoid::CachedJson

  field :url
  field :title

  has_many :articles

  belongs_to :site

  json_fields \
    url: { },
    title: { },
    articles: { definition: :articles_json }

  def update_article(attributes)
    article = Article.find_or_initialize_by(url: attributes[:url])
    article.update_attributes!(attributes)
    self.articles << article
    self.save!
    # puts "Updated article #{article.title}"
  end

  def articles_json
    return articles.as_json
  end

  private :articles_json
end
