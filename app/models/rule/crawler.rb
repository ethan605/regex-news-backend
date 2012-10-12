require 'open-uri'

class Rule::Crawler
  SITE_RULES = {
    'vnexpress.net' => {
      url: 'http://vnexpress.net',
      title: 'VnExpress',
      categories: {
        urls: {
          'Xa Hoi' => '/gl/xa-hoi',
          'The Gioi' => '/gl/the-gioi',
          'Kinh Doanh' => '/gl/kinh-doanh',
          'Phap Luat' => '/gl/phap-luat',
          'Gia Dinh - Suc Khoe' => '/gl/doi-song',
          'Khoa Hoc' => '/gl/khoa-hoc',
          'Oto - Xe May' => '/gl/oto-xe-may',
          'Ban Doc Viet' => '/gl/ban-doc-viet'
        },
        selectors: [
          '#content .folder-top',
          '#content .folder-news'
        ],
        rules: {
          url: '(?<=<a href=")[^>"]*',
          title: '(?<=>)[\w[^<]]+',
          image: '(?<=src=")[^>"]*',
          spoiler: '(?<=<p>)[^<]+?(?=<)'
        }
      }
    }
  }
  
  def self.vne
    Article.delete_all
    Category.delete_all
    Site.delete_all

    # agent = Mechanize.new
    # page = Nokogiri::HTML(agent.get('http://vnexpress.net/gl/xa-hoi').content)

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
      
      # Categories
      rules = properties[:categories][:rules]
      
      properties[:categories][:urls].each do |title, url|
        category = site.update_category({title: title, url: "http://#{domain}#{url}"})
        puts "\nCrawled category: #{category.title}"
        # page = Nokogiri::HTML(Mechanize.new.get("http://#{domain}#{url}").content)
        page = Nokogiri::HTML(open("http://#{domain}#{url}"))
        
        properties[:categories][:selectors].each do |selector|
          news = page.css(selector)
          news.each do |content|
            content = content.to_html
            content.gsub!(*Rule::STRIP_BETWEEN_TAGS)
            content.gsub!(*Rule::STRIP_BEFORE_TAGS)
            content.gsub!(*Rule::STRIP_AFTER_TAGS)

            attributes = {}
            rules.each do |field, rule|
              attributes[field] = ensure_url(content[/#{rule}/], domain) if content[/#{rule}/]
            end

            if (attributes[:spoiler])
              category.update_article(attributes)
              puts "Crawled article: #{attributes[:title]}"
            end
          end
        end
      end

      return
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