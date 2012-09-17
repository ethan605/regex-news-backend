module Rule::RegEx
  extend ActiveSupport::Concern

  STRIP_BETWEEN_TAGS  = [/(?<=>)[\s\n\r\t]*(?=<)/m, '']
  STRIP_BEFORE_TAGS   = [/[\n\r\t]*(?=<)/m, '']
  STRIP_AFTER_TAGS    = [/(?<=>)[\n\r\t]*/m, '']
  STRIP_CONTROLS      = [/[\n\r\t]+/m, ' ']
  REMOVE_INPUTS       = [/<input[^>]*>/m, '']
  CHANGE_ELEMENTS     = {
    '24h.com.vn' => {
      '\/\/<!\[CDATA\[.*?\/\/\]\]>' => '',
      '<script.*?</script>' => '',
      'style="background:url[^"]*"' => '',
      'favicon.gif' => 'favicon.ico',
      '(?<==["|\'])/(?=(js|css|favicon))' => 'http://www.24h.com.vn/',
      '(?<=href=["|\'])/' => '/sites?url=http://24h.com.vn/',
      '(?<==["|\'])http://www.24h.com.vn/(?!(js|css|favicon))' => '/sites?url=http://www.24h.com.vn/',
      '<div class="header(-inside)*".*(?=<table width="1004")' => '',
      '<div class="header".*(?=<div class="content")' => '',
      '<ul id="submenu.*?</ul>' => '',
      '<td id="cRight".*(?=</tr>)' => '',
      '<div class="shareFB-green".*(?=<div (class="baiviet-tags"|id="relate_news"))' => '',
      '<div class="div-banner300250".*</td>' => '',
      '<div id="comment_content".*(?=<div id="relate_news")' => '',
      '<div class="footer".*(?=</body>)' => '</div>',
      '(?<=<div class="phantrang">).*?(?=</div>)' => '',
      '<div class="theoNgay".*?</div>' => '',
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
      '<object.*?</object>' => '',
      '<p class="like".*?</a></p>' => '',
      '<div class="social clearfix".*?</ul></div>' => '',
      '<div class="starworld clearfix".*(?=<div class="mainbox clearfix ads">)' => '',
      '<div class="story-feature grid_7 alpha" id="survey".*<p>&nbsp;</p><p>&nbsp;</p><br />' => '',
      '<div id="footer".*(?=<img)' => '',
      '<div class="ads".*?</table></div>' => '',
      'grid_16' => 'grid_24',
    },
    'dantri.com.vn' => {
      '<script.*?</script>' => '',
      '(?<=href=["\'])/(?!App_Themes/Default/Images/favico.ico)' => '/sites?url=http://dantri.com.vn/',
      '(?<=<link rel="Shortcut Icon" href=")/' => 'http://dantri.com.vn/',
      '(?<=href=["|\'])http://(?=dantri.com.vn)' => '/sites?url=http://',
      '<div class="header".*(?=<div class="nav-wrap">)' => '',
      '<div class="footer box19".*(?=</form>)' => '',
      '<OBJECT.*?</OBJECT>' => '',
      '<div class="emailprint".*?</div>' => '',
      '<div class="newest-of-cat".*(?=<div class="fl wid470")' => '',
      '<div class="fl wid310 box5 admicro".*(?=</div></div></div>)' => '',
      '<div itemscope itemtype=.*</script>' => '',
      '<div class="fl wid470"' => '<div class="fl"'
    },
    'kenh14.vn' => {
      '<script.*?</script>' => '',
      '(?<==["\'])/' => '/sites?url=http://kenh14.vn/',
      '<div class="scrolltopwrapper clearfix".*(?=<div class="menuwrapper")' => '',
      '<div class="subheader".*(?=<div class="submenu_container")' => '',
      '<div class="subheader".*?</a>' => '',
      '<div class="details_top_like".*(?=<div class="author")' => '',
      '<div class="post-share".*(?=<div id="vcm_tagsNews")' => '',
      '<div class="postsep".*(?=<div class="relatebox")' => '',
      '<div class="adzone6".*(?=</div></div></div></form>)' => '',
      '<div class="dateselector".*?</div></div>' => '',
      '<div id="TieuDiemPhai".*(?=<div class="maincontent clearfix")' => '',
      '<div class="adzone4 ads_by_admicro".*?</div></div>' => '',
      '<div (id|class)="(?!homepageboxlast)[^<]*</div>' => ''
    },
    'vnexpress.net' => {
      '\/\/<!\[CDATA\[.*?\/\/]]>' => '',
      '<script.*?</script>' => '',
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