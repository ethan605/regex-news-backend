class Rule
  include Mongoid::Document
  
  STRIP_BETWEEN_TAGS  = [/>[\s\n\r\t]*</m, '><']
  STRIP_BEFORE_TAGS   = [/[\n\r\t]*</m, '<']
  STRIP_AFTER_TAGS    = [/>[\n\r\t]*/m, '>']
  STRIP_CONTROLS      = [/[\n\r\t]+/m, ' ']
  REMOVE_SCRIPTS      = [/<script[^<]*<\/script>/m, '']
  CHANGE_ELEMENTS     = {
    'dantri.com.vn' => {
      '<input[^>]*/>' => '',
      'href="/' => 'href="http://localhost:3000/sites?url=http://dantri.com.vn/',
      'href=\'/' => 'href=\'http://localhost:3000/sites?url=http://dantri.com.vn/',
      'a href="http://dantri' => 'a href="http://localhost:3000/sites?url=http://dantri',
      'a href=\'http://dantri' => 'a href=\'http://localhost:3000/sites?url=http://dantri',
      '(?<=<link rel="Shortcut Icon" href=")/' => 'http://dantri.com.vn/',
      '<div class="header".*(?=<div class="nav-wrap">)' => '',
      '<div class="footer box19".*(?=</form>)' => '',
      '<div class="newest-of-cat".*(?=<div class="fl wid470")' => '',
      '<div class="fl wid310 box5 admicro".*(?=</div></div></div>)' => '',
      '<div itemscope itemtype=.*</script>' => '',
      '<div class="fl wid470"' => '<div class="fl"'
    },
    'bongdaplus.vn' => {
      '(?<==("|\'))\s*/' => 'http://bongdaplus.vn/',
      '(?<=href=("|\'))http://(?!bongdaplus.vn/(App_Themes/Default|favicon.ico))' => 'http://localhost:3000/sites?url=http://',
      '<div id="toolbar".*(?=<div class="foldwrap")' => '<div class="foldwrap">',
      '<table id="ctl00_Footer_Embedded_Ads_Script".*</table>' => '',
      '<div class="sidebar grid_8 omega">.*</script>' => '</div></div>',
      '<div class="sidebar grid_8 omega">.*(?=<div id="footer-ads")' => '</div></div>',
      '<div id="most-read-stories".*(?=<img)' => '',
      '(?<=<div class="story-body">)<object.*</object>' => '',
      '<div class="starworld clearfix".*(?=<div class="mainbox clearfix ads">)' => '',
      'grid_16' => 'grid_24'
    }
  }
 
  def self.apply(url)
    content = Mechanize.new.get(url).content

    content.gsub!(*STRIP_BETWEEN_TAGS)
    content.gsub!(*STRIP_BEFORE_TAGS)
    content.gsub!(*STRIP_AFTER_TAGS)
    content.gsub!(*STRIP_CONTROLS)
    content.gsub!(*REMOVE_SCRIPTS)

    hostname = url[/http[s]*:\/\/(www.)*[\w\-.]+/][/(?<=\/\/)[\w\-\.]+/]
    CHANGE_ELEMENTS[hostname].each do |k, v|
      content.gsub!(/#{k}/m, v)
    end

    return content
  end
end
