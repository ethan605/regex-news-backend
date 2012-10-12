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
          'Ban Doc Viet' => '/gl/ban-doc-viet',
          'Tam Su' => '/gl/ban-doc-viet/tam-su'
        },
        selectors: [
          '#content .folder-top',
          '#content .folder-news'
        ],
        rules: {
          url: { 'a' => '(?<=href=")[^>"]*' },
          title: { 'p > a' => '(?<=>)[\w[^\r\n<]]+' },
          image: { 'a > img' => '(?<=src=")[^>"]+' },
          spoiler: { 'p:nth-of-type(2)' => '(?<=<p>)[^<]+?(?=<)' }
        }
      }
    },
    'dantri.com.vn' => {
      url: 'http://dantri.com.vn',
      title: 'Dan Tri',
      categories: {
        urls: {
          'Su Kien' => '/c728/sukien.htm',
          'Xa Hoi' => '/c20/xahoi.htm',
          'The Gioi' => '/c36/thegioi.htm',
          'The Thao' => '/c26/thethao.htm',
          'Giao Duc' => '/c25/giaoduc.htm',
          'Nhan Ai' => '/c167/tamlongnhanai.htm',
          'Kinh Doanh' => '/c76/kinhdoanh.htm',
          'Van Hoa' => '/c730/vanhoa.htm',
          'Giai Tri' => '/c23/giaitri.htm',
          'Phap Luat' => '/c170/skphapluat.htm',
          'Nhip Song Tre' => '/c135/nhipsongtre.htm',
          'Tinh Yeu' => '/c130/tinhyeu-gioitinh.htm',
          'Suc Khoe' => '/c7/suckhoe.htm',
          'Suc Manh So' => '/c119/sucmanhso.htm',
          'Oto Xe May' => '/c111/otoxemay.htm',
          'Chuyen La' => '/c132/chuyenla.htm',
          'Ban Doc' => '/c202/diendanbandoc.htm'
        },
        selectors: [
          '.mt3.clearfix'
        ],
        rules: {
          url: { '.mr1 > a' => '(?<=href=")[^>"]*' },
          title: { '.mr1 > a' => '(?<=>)[\w[^<]]+' },
          image: { 'a > img' => '(?<=src=")[^>"]*' },
          spoiler: { '.fon5' => '(?<=>)[\w[^<]]+' }
        }
      }
    }
  }
  
  def self.crawl_all
    Article.delete_all
    Category.delete_all
    Site.delete_all

    SITE_RULES.each do |domain, properties|
      crawl(domain)
    end
  end

  def self.crawl(domain)
    properties = SITE_RULES[domain]
    url = properties[:url]
    page = Nokogiri::HTML(open(url))
    
    # Init site
    site = Site.find_or_initialize_by(url: url)
    attributes = {
      update_time: DateTime.now,
      title: properties[:title]
    }
    site.update_attributes!(attributes)
    puts "==========\nCrawling site: #{domain}"
    
    # Categories
    rules = properties[:categories][:rules]
    
    properties[:categories][:urls].each do |title, url|
      category = site.update_category({title: title, url: "http://#{domain}#{url}"})
      puts "\nCrawling category: #{category.title}"

      page = Nokogiri::HTML(open("http://#{domain}#{url}"))
      properties[:categories][:selectors].each do |selector|
        news = page.css(selector)
        news.each do |content|
          attributes = {}
          rules.each do |field, rule|
            rule.map do |sel, regex|
              html = content.css(sel).first
              if html
                html = html.to_html
                attributes[field] = ensure_url(html[/#{regex}/], domain) if html[/#{regex}/]
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

    puts "=========="
    return
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