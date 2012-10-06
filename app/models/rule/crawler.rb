require 'open-uri'

class Rule::Crawler
  SITE_RULES = {
    'vnexpress.net' => {
      url: 'http://vnexpress.net',
      title: 'VnExpress',
      content: {
        top: {
          selectors: [
            '#top4 .hotnews-detail',
            '#top4 .t3-content'  
          ],
          rule: {
            url: '(?<=<a href=")[^>"]*',
            title: '(?<=>)[\w[^<]]+',
            image: '(?<=src=")[^>"]*',
            spoiler: '(?<=<p>)[^>]*(?=<\/p>)'
          }
        },
        categories: {
          lists: [
            '/gl/xa-hoi',
          ],
          selectors: [
            '#content .folder-top',
            '#content .folder-news'
          ],
          rule: {
            url: '(?<=<a href=")[^>"]*',
            title: '(?<=>)[\w[^<]]+',
            image: '(?<=src=")[^>"]*',
            spoiler: '(?<=<p>)[^>]*(?=<\/p>)'
          }
        }
      }
    }
  }
  
  def self.vnexpress
    Article.delete_all
    Category.delete_all
    Site.delete_all

    agent = Mechanize.new
    page = Nokogiri::HTML(agent.get('http://vnexpress.net/gl/xa-hoi').content)

    SITE_RULES.each do |domain, properties|
      url = properties[:url]
      page = Nokogiri::HTML(open(url))
      
      # Init site
      site = Site.find_or_initialize_by(url: url)
      attributes = {
        update_time: DateTime.now,
        title: properties[:title]
      }
      site.update_attributes!(attributes)

      # Top news
      category = site.update_category(title: "Top news")
      rule = properties[:content][:top][:rule]
      properties[:content][:top][:list].each do |selector|
        news = page.css(selector)
        news.each do |content|
          content = content.to_html
          content.gsub!(*Rule::STRIP_BETWEEN_TAGS)
          content.gsub!(*Rule::STRIP_BEFORE_TAGS)
          content.gsub!(*Rule::STRIP_AFTER_TAGS)

          attributes = {}
          rule.each do |field, rule|
            attributes[field] = ensure_url(content[/#{rule}/], domain) if content[/#{rule}/]
          end

          category.update_article(attributes)
        end
      end

      # Categories news
      category = site.update_category({title: "Xa hoi", url: "http://vnexpress.net/gl/xa-hoi")
      rule = properties[:content][:top][:rule]
      properties[:content][:top][:list].each do |selector|
        news = page.css(selector)
        news.each do |content|
          content = content.to_html
          content.gsub!(*Rule::STRIP_BETWEEN_TAGS)
          content.gsub!(*Rule::STRIP_BEFORE_TAGS)
          content.gsub!(*Rule::STRIP_AFTER_TAGS)

          attributes = {}
          rule.each do |field, rule|
            attributes[field] = ensure_url(content[/#{rule}/], domain) if content[/#{rule}/]
          end

          category.update_article(attributes)
        end
      end
    end
  end

  def self.ensure_url(url, domain)
    return url unless url =~ /^\//

    url_pattern = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
    unless url =~ url_pattern
      return "http://#{domain}" + url
    else
      return url
    end
  end
end