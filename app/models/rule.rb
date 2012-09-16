class Rule
  include Mongoid::Document
  
  STRIP_BETWEEN_TAGS  = [/(?<=>)[\s\n\r\t]*(?=<)/m, '']
  STRIP_BEFORE_TAGS   = [/[\n\r\t]*(?=<)/m, '']
  STRIP_AFTER_TAGS    = [/(?<=>)[\n\r\t]*/m, '']
  STRIP_CONTROLS      = [/[\n\r\t]+/m, ' ']
  REMOVE_INPUTS       = [/<input[^>]*>/m, '']
  CHANGE_ELEMENTS     = {
    'vnexpress.net' => {
      '<script[^<]*</script>' => '',
      '<input[^>]*>' => '',
      '(?<=href=["\'])/(?=([Ll]ibrary|[Rr]esource|[Ii]mages|[Ff]iles))' => 'http://vnexpress.net/',
      '(?<=src=["\'])/(?=([Ll]ibrary|[Rr]esource|[Ii]mages|[Ff]iles))' => 'http://vnexpress.net/',
      '(?<=href=["\'])/' => 'http://localhost:3000/sites?url=http://vnexpress.net/',
      '<div class="fpr2".*(?=<div id="menu")' => '',
      '<div id="mn-search".*(?=<div class="menu">)' => '</div>',
      '<div id="footer".*(?=</body>)' => '</div></div>',
      '<div class="likesubject fl".*(?=<div class="tag-parent">)' => '',
      '<div class="box-item".*(?=<div class="Div_OtherNews">)' => '</div>',
      '<div id="linksiteEH".*(?=</div><div id="content")' => '',
      '<div class="content-left fl".*(?=</body>)' => '</div></div></div>',
      '(?<=<div class="content-center fl")' => ' style="width: 990px"',
      '(?<=<div class="folder-header")' => ' style="width: 990px"'
    },
    'dantri.com.vn' => {
      '<script[^<]*</script>' => '',
      '<input[^>]*>' => '',
      '(?<=href=["\'])/(?!App_Themes/Default/Images/favico.ico)' => 'http://localhost:3000/sites?url=http://dantri.com.vn/',
      '(?<=<link rel="Shortcut Icon" href=")/' => 'http://dantri.com.vn/',
      '<div class="header".*(?=<div class="nav-wrap">)' => '',
      '<div class="footer box19".*(?=</form>)' => '',
      '<div class="newest-of-cat".*(?=<div class="fl wid470")' => '',
      '<div class="fl wid310 box5 admicro".*(?=</div></div></div>)' => '',
      '<div itemscope itemtype=.*</script>' => '',
      '<div class="fl wid470"' => '<div class="fl"'
    },
    'bongdaplus.vn' => {
      '(?<=["\'])/(?=(JScripts|Uploaded))' => 'http://bongdaplus.vn/',
      '(?<==["\'])\s*/' => 'http://bongdaplus.vn/',
      '(?<=href=["\'])http://(?!bongdaplus.vn/(App_Themes/Default|favicon.ico))' => 'http://localhost:3000/sites?url=http://',
      '<div id="top-adv".*(?=<div class="foldwrap")' => '<div class="foldwrap">',
      '<table id="ctl00_Footer_Embedded_Ads_Script".*</table>' => '',
      '<div class="sidebar grid_8 omega">.*</script>' => '</div></div>',
      '<div class="sidebar grid_8 omega">.*(?=<div id="footer-ads")' => '</div></div>',
      '<div id="most-read-stories".*(?=<img)' => '',
      '(?<=<div class="story-body">)<object.*</object>' => '',
      '<div class="starworld clearfix".*(?=<div class="mainbox clearfix ads">)' => '',
      '<div class="story-feature grid_7 alpha" id="survey".*<p>&nbsp;</p><p>&nbsp;</p><br />' => '',
      '<div id="footer".*(?=<img)' => '',
      'grid_16' => 'grid_24'
    }
  }
 
  def self.apply(url)
    content = Mechanize.new.get(url).content

    content.gsub!(*STRIP_BETWEEN_TAGS)
    content.gsub!(*STRIP_BEFORE_TAGS)
    content.gsub!(*STRIP_AFTER_TAGS)
    content.gsub!(*STRIP_CONTROLS)

    hostname = url[/http[s]*:\/\/(www.)*[\w\-.]+/][/(?<=\/\/)[\w\-\.]+/]
    CHANGE_ELEMENTS[hostname].each do |k, v|
      content.gsub!(/#{k}/m, v)
    end

    return content
  end
end
