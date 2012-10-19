require 'open-uri'

class Crawler
  include Crawler::SiteRules
  include Rule::CommonRules
  
  def self.crawl_all
    Article.delete_all
    Category.delete_all
    Site.delete_all

    crawler = Crawler.new

    SITE_RULES.each do |domain, properties|
      crawler.crawl(domain)
    end
  end

  def crawl(domain)
    @domain = domain
    @properties = SITE_RULES[@domain]
    url = "http://#{domain}"
    page = Nokogiri::HTML(open(url))
    
    # Init site
    @site = Site.find_or_initialize_by(url: url)
    attributes = {
      update_time: DateTime.now,
      title: @properties[:title]
    }
    @site.update_attributes!(attributes)
    puts "==========\nCrawling site: #{domain}"
    
    # Categories
    @rules = @properties[:categories][:rules]
    
    @properties[:categories][:urls].each do |title, urls|
      if urls.is_a?Array
        urls.each do |url|
          crawl_url(title, url)
        end
      else
        crawl_url(title, urls)
      end
    end

    puts "=========="
    return
  end

  def crawl_url(title, url)
    category = @site.update_category({title: title, url: "http://#{@domain}#{url}"})
    puts "\nCrawling category: #{category.title} from url: http://#{@domain}#{url}"

    page = Nokogiri::HTML(open("http://#{@domain}#{url}"))
    @properties[:categories][:selectors].each do |selector|
      news = page.css(selector)
      news.each do |content|
        attributes = {}
        @rules.each do |field, rule|
          rule.map do |sel, regex|
            html = content.css(sel).first
            if html
              html = html.to_html
              html.gsub!(*REMOVE_CONTROLS)
              attributes[field] = ensure_url(html[/#{regex}/], @domain) if html[/#{regex}/]
            end
          end
        end

        if (attributes[:spoiler])
          category.update_article(attributes)
          puts "Crawled article: #{attributes[:title]}"
        end
      end
    end
  end

  def ensure_url(url, domain)
    return url unless url =~ /^\//

    url_pattern = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
    unless url =~ url_pattern
      return "http://#{domain}" + url
    else
      return url
    end
  end

  def self.crawl_header
    page = Mechanize.new.get('http://ngoisao.net')
    page = Nokogiri.HTML(page.content)
    menus = page.css("#menu > li")

    menus.each do |menu|
      urls = menu.css('ul > li > a')
      urls = urls.map { |url| url[:href] }
      urls = urls.join("','")
      "'#{menu[:id]}' => ['#{urls}']"
    end
  end
end