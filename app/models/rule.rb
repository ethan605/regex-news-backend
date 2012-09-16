class Rule
  include Mongoid::Document
  include Rule::RegEx

  field :domain
  field :rules

  scope :domain, ->(_domain) { return self.where(domain: _domain) }

  def self.map_rules
    CHANGE_ELEMENTS.each do |domain, rules|
      rule = Rule.find_or_initialize_by(domain: domain)
      rule.rules = rules
      rule.save
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
    rule = Rule.domain(domain).first

    return 'Domain not processed' unless rule

    rule.rules.each do |from, to|
      content.gsub!(/#{from}/m, to)
    end

    return content
  end
end
