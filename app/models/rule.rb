class Rule
  include Mongoid::Document
  include Mongoid::CachedJson
  include Rule::RegEx

  field :domain
  field :rules

  scope :domain, ->(_domain) { return self.where(domain: _domain) }

  json_fields \
    domain: { },
    rules: { }

  def self.map_rules
    Rule.delete_all
    CHANGE_ELEMENTS.each do |domain, rules|
      rule = Rule.find_or_initialize_by(domain: domain)
      rule.rules = rules
      puts "#{rule.save}"
    end
  end
 
  def self.apply_rules(url)
    content = Mechanize.new.get(url).content

    content.gsub!(*STRIP_BETWEEN_TAGS)
    content.gsub!(*STRIP_BEFORE_TAGS)
    content.gsub!(*STRIP_AFTER_TAGS)
    content.gsub!(*STRIP_CONTROLS)
    content.gsub!(*REMOVE_INPUTS)

    domain = url[/http[s]*:\/\/(www.)*[\w\-.]+/][/(?<=\/\/)[\w\-\.]+/]
    
    # rule = Rule.domain(domain).first
    
    # return nil unless rule
    # rule.rules.each do |from, to|
    #   content.gsub!(/#{from}/m, to)
    # end

    CHANGE_ELEMENTS[domain].each do |from, to|
      content.gsub!(/#{from}/m, to)
    end

    return content
  end

  def self.sha
    digest = OpenSSL::Digest::Digest.new('sha256')
    public_key = Digest::SHA2.new(256) << 'regex-news-backend'
    private_key = Digest::SHA2.new(384) << 'regex-news-backend'

    hmac = OpenSSL::HMAC.hexdigest(digest, private_key.to_s, Auth.convert_params)
  end
end
