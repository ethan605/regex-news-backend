class Rule::Crawler
  def self.vne
    Article.delete_all
    Category.delete_all
    Site.delete_all

    domain = 'vnexpress.net'
    agent = Mechanize.new
    page = Nokogiri::HTML(agent.get("http://#{domain}").content)

    # Init site
    site = Site.new(url: "http://#{domain}", title: domain)
    site.save!

    # Init category - Top news
    category = Category.new(title: "[#{domain}] Top news")
    category.save!
    site.tops << category
    site.save!

    # Top news
    top_news = page.css('#top4 .hotnews-detail p')
    url = "http://#{domain}" + top_news[0].css('a')[0][:href]
    attributes = {
      title: top_news[0].css('a')[1].text,
      image: "http://#{domain}" + top_news[0].css('img')[0][:src],
      spoiler: top_news[1].text.gsub(/>.*/, '')
    }

    # Top news - main article
    article = Article.find_or_initialize_by(url: url)
    article.update_attributes!(attributes)

    category.mains << article
    category.save!

    # Top news - sub articles
    top_news = page.css('#topnews .t3-content.fl')
    top_news.each do |content|
      url = content.css('p a')[0][:href]
      attributes = {
        title: content.css('p a')[1].text,
        image: "http://#{domain}" + content.css('p img')[0][:src]
      }

      article = Article.find_or_initialize_by(url: url)
      article.update_attributes!(attributes)

      category.subs << article
      category.save!
    end
  end
end