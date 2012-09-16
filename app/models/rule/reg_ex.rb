module Rule::RegEx
  extend ActiveSupport::Concern

  STRIP_BETWEEN_TAGS  = [/(?<=>)[\s\n\r\t]*(?=<)/m, '']
  STRIP_BEFORE_TAGS   = [/[\n\r\t]*(?=<)/m, '']
  STRIP_AFTER_TAGS    = [/(?<=>)[\n\r\t]*/m, '']
  STRIP_CONTROLS      = [/[\n\r\t]+/m, ' ']
  REMOVE_INPUTS       = [/<input[^>]*>/m, '']
  CHANGE_ELEMENTS     = {
    '24h.com.vn' => {
      '<script[^<]*</script>' => '',
      'style="background:url[^"]*"' => '',
      'favicon.gif' => 'favicon.ico',
      '(?<==["|\'])/(?=(js|css|favicon))' => 'http://www.24h.com.vn/',
      '(?<=href=["|\'])/' => '/sites?url=http://24h.com.vn/',
      '<div class="header(-inside)*".*(?=<table width="1004")' => '',
      '<div class="shareFB-green".*(?=<div class="baiviet-tags")' => '',
      '<div class="div-banner300250".*</td>' => '',
      '<ul id="submenu.*(?=<div id="tin_tieu_diem")' => '',
      '<div class="footer".*(?=</body>)' => '</div>'
    },
    'bongdaplus.vn' => {
      '(?<==["\'])/(?=(JScripts|Uploaded))' => 'http://bongdaplus.vn/',
      '(?<==["\'])\s*/' => 'http://bongdaplus.vn/',
      '(?<=href=["\'])http://(?!bongdaplus.vn/(App_Themes/Default|favicon.ico))' => '/sites?url=http://',
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
    },
    'dantri.com.vn' => {
      '<script[^<]*</script>' => '',
      '(?<=href=["\'])/(?!App_Themes/Default/Images/favico.ico)' => '/sites?url=http://dantri.com.vn/',
      '(?<=<link rel="Shortcut Icon" href=")/' => 'http://dantri.com.vn/',
      '<div class="header".*(?=<div class="nav-wrap">)' => '',
      '<div class="footer box19".*(?=</form>)' => '',
      '<div class="newest-of-cat".*(?=<div class="fl wid470")' => '',
      '<div class="fl wid310 box5 admicro".*(?=</div></div></div>)' => '',
      '<div itemscope itemtype=.*</script>' => '',
      '<div class="fl wid470"' => '<div class="fl"'
    },
    'vnexpress.net' => {
      '<script[^<]*</script>' => '',
      '(?<=href=["\'])/(?=([Ll]ibrary|[Rr]esource|[Ii]mages|[Ff]iles))' => 'http://vnexpress.net/',
      '(?<=src=["\'])/(?=([Ll]ibrary|[Rr]esource|[Ii]mages|[Ff]iles))' => 'http://vnexpress.net/',
      '(?<=href=["\'])/' => '/sites?url=http://vnexpress.net/',
      '<div class="fpr2".*(?=<div id="menu")' => '',
      '<div id="mn-search".*(?=<div class="menu">)' => '</div>',
      '<div id="footer".*(?=</body>)' => '</div></div>',
      '<div class="email-print txtr".*(?=<div class="content")' => '',
      '<div class="likesubject fl".*(?=<div class="tag-parent")' => '',
      '<div class="box-item".*(?=<div class="Div_OtherNews")' => '</div>',
      '<div id="linksiteEH".*(?=</div><div id="content")' => '',
      '<div class="content-left fl".*(?=</body>)' => '</div></div></div>',
      '(?<=<div class="content-center fl")' => ' style="width: 990px"',
      '(?<=<div class="folder-header")' => ' style="width: 990px"'
    }
  }
end