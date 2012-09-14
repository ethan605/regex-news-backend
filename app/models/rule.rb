class Rule
  include Mongoid::Document
  
  STRIP_BETWEEN_TAGS  = [/>[\s\n\r\t]*</m, '><']
  STRIP_BEFORE_TAGS   = [/[\n\r\t]*</m, '<']
  STRIP_AFTER_TAGS    = [/>[\n\r\t]*/m, '>']
  STRIP_CONTROLS      = [/[\n\r\t]+/m, ' ']
  REMOVE_SCRIPTS      = [/<script[^<]*<\/script>/m, '']
  REMOVE_ELEMENTS     = [
    '<div class="header".*(?=<div class="nav-wrap">)',
    '<div class="event-by-zone".*(?=<div class="wrapper">)',
    '<div class="footer box19".*(?=</form>)',
    '<div class="newest-of-cat".*(?=<div class="fl wid470")',
    '<div class="fl wid310 box5 admicro".*(?=</div></div></div>)'
  ]
 
  def self.apply(url)
    content = Mechanize.new.get(url).content

    content.gsub!(*STRIP_BETWEEN_TAGS)
    content.gsub!(*STRIP_BEFORE_TAGS)
    content.gsub!(*STRIP_AFTER_TAGS)
    content.gsub!(*STRIP_CONTROLS)
    content.gsub!(/(#{REMOVE_ELEMENTS.join('|')})/m, '')

    return content
  end
end
