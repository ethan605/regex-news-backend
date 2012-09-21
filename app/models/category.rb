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

  def update_topic(name, attributes)
    article = Article.find_or_initialize_by(url: attributes[:url])
    article.update_attributes!(attributes)
    self.send("update_#{name}", article)
  end

  def update_main(article)
    self.mains << article
    self.save!
  end

  def update_sub(article)
    self.subs << article
    self.save!
  end

  def update_other(article)
    self.others << article
    self.save!
  end

  def main_news
    return mains.as_json
  end

  def sub_news
    return subs.as_json
  end

  def other_news
    return others.as_json
  end

  private :main_news, :sub_news, :other_news, :update_main, :update_sub, :update_other
end
