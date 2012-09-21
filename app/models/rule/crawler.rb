require 'open-uri'

class Rule::Crawler
  def self.vne
    Article.delete_all
    Category.delete_all
    Site.delete_all

    domain = 'vnexpress.net'
    page = Nokogiri::HTML(open("http://#{domain}"))

    # Init site
    site = Site.new(url: "http://#{domain}", title: domain)
    site.save!

    category = site.update_category('top', title: "[#{domain}] Top news")

    # Top news - main article
    news = page.css('#top4 .hotnews-detail')
    news.each do |content|
      attributes = {
        url: ensure_url(content.css('a')[0][:href], domain),
        title: content.css('a')[1].text,
        image: ensure_url(content.css('img')[0][:src], domain),
        spoiler: content.css('p')[1].text.gsub(/>.*/, '')
      }
      category.update_topic('main', attributes)
    end

    # Top news - sub articles
    news = page.css('#topnews .t3-content')
    news.each do |content|
      attributes = {
        url: ensure_url(content.css('a')[0][:href], domain),
        title: content.css('a')[1].text,
        image: ensure_url(content.css('img')[0][:src], domain)
      }
      category.update_topic('sub', attributes)
    end

    # Top news - other articles
    news = page.css('#toplist .toplist-content2 li a')
    news.each do |content|
      attributes = {
        url: ensure_url(content[:href], domain),
        title: content.text
      }
      category.update_topic('other', attributes)
    end

    ## Content categories
    contents = page.css('#content .folder')
    contents.delete(contents.last)
    contents.each do |content|
      attributes = {
        url: ensure_url(content.css('[class^="folder-active"] a')[0][:href], domain),
        title: content.css('[class^="folder-active"] a')[0].text
      }
      category = site.update_category('content', attributes)

      # Content category - Main article
      news = content.css('.folder-topnews')[0]
      attributes = {
        url: ensure_url(news.css('a')[0][:href], domain),
        title: news.css('a')[1].text,
        image: ensure_url(news.css('img')[0][:src], domain),
        spoiler: news.css('p')[1].text.gsub(/>.*/,'')
      }
      category.update_topic('main', attributes)

      # Content category - Sub articles
      news = content.css('.folder-othernews div[class^="other-folder"]')[0]
      if news
        attributes = {
          url: ensure_url(news.css('a')[0][:href], domain),
          title: news.css('a')[1].text,
          image: ensure_url(news.css('img')[0][:src], domain)
        }

        category.update_topic('sub', attributes)
      end

      # Content category - Other articles
      news = content.css('.folder-othernews div[class^="fl"] ul li a')
      news.each do |content|
        attributes = {
          url: ensure_url(content[:href], domain),
          title: news.text
        }
        category.update_topic('other', attributes)
      end
    end
  end

  def self.ensure_url(url, domain)
    url_pattern = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
    unless url =~ url_pattern
      return "http://#{domain}" + url
    else
      return url
    end
  end
end