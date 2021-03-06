module Rule::ArticleRules
  extend ActiveSupport::Concern

  CHANGE_ELEMENTS = {
    '24h.com.vn' => {
      '\/\/<!\[CDATA\[.*?\/\/\]\]>' => '',
      '<script.*?</script>' => '',
      'style="background:url[^"]*"' => '',
      'favicon.gif' => 'favicon.ico',
      '(?<==["\'])/(?=(js|css|favicon))' => 'http://www.24h.com.vn/',
      '(?<=href=["\'])/' => '/sites?url=http://24h.com.vn/',
      '(?<==["\'])http://www.24h.com.vn/(?!(js|css|favicon))' => '/sites?url=http://www.24h.com.vn/',
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
      '<div class="divChonNgay".*?</form></div>' => ''
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
      '(?<=href=["\'])http://(?=dantri.com.vn)' => '/sites?url=http://',
      '(?<=<link rel="Shortcut Icon" href=")/' => 'http://dantri.com.vn/',
      '(?<=href=["\'])/' => '/sites?url=http://dantri.com.vn/',
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
    'news.zing.vn' => {
      '<script.*?</script>' => '',
      '(?<=href=["\'])/' => '/sites?url=http://news.zing.vn/',
      '(?<=href=["\'])http://(?=news.zing.vn)' => '/sites?url=http://',
      '<div class="zingtop".*(?=<div class="zingcomponent")' => '',
      '<p class="local_timer".*?</p>' => '',
      '<div class="topnews_slideshow" id="topnew_slideshow_2".*?(?=<ul)' => '</div>',
      '<div class="sidecol_blk02 blk_topphoto".*?(?=<div class="sidecol_blk04 blk_topicnews")' => '',
      '<div class="sidecol_blk03 hotline_box".*?(?=<div class="sidecol_blk04 blk_topicnews")' => '',
      '<div class="newsfilter".*(?=<div class="znews_rightcol")' => '</div>',
      '<p class="followZinglive".*?</p>' => '',
      '<div class="share_link".*<!-- begin: Footer -->' => '</div></div></div>',
      '<iframe.*?</iframe>' => '',
      '<div class="znews_footer".*(?=</body>)' => '',
      '(?<=<!-- begin: left column --><div class="znews_leftcol")' => ' style="width: 980px"',
      '(?<=<div class="newsdetail_wrapper")' => ' style="width: 815px"'
    },
    'ngoisao.net' => {
      '<script.*?</script>' => '',
      '(?<=href=["\'])http://(?=ngoisao.net)' => '/sites?url=http://',
      '(?<=href=["\'])/(?=([Rr]esource|[Ss]ervice|[Ll]ibrary|[Ii]mages|[Ff]iles))' => 'http://ngoisao.net/',
      '(?<=src=["\'])/(?=([Rr]esource|[Ss]ervice|[Ll]ibrary|[Ii]mages|[Ff]iles))' => 'http://ngoisao.net/',
      '(?<=href=["\'])/' => '/sites?url=http://ngoisao.net/',
      '(?<=url\()/[Ii]mages/[^\)]*' => '',
      '<div id="taskbar_top".*(?=<div id="wrapper-container")' => '',
      '<div id="header".*(?=<div id="content")' => '',
      '<div id="footer".*(?=</body>)' => '</div></div></div>',
      '<div class="topDetail".*?(?=<H1)' => '',
      '<div class="detailNS".*(?=<div class="relateNewsDetail")' => '',
      '<div class="adv".*(?=<div class="Div_OtherNews")' => '',
      '<div class="tnhome".*(?=<div class=["\']backStage)' => '',
      '<div class="midAd".*(?=<div class="fl httw")' => '',
      '<div class="ad-right-home".*?(?=<div class="fl [c]*nop")' => ''
    },
    'tiin.vn' => {
      '<script.*?</script>' => '',
      '(?<=src=["\'])/(?=theme)' => 'http://tiin.vn/',
      '(?<=href=["\'])/(?!favicon.ico)' => '/sites?url=http://tiin.vn/',
      '/favicon.ico' => 'http://tiin.vn/favicon.ico',
      '(?<=url)\([^\)]*' => '(',
      '<div id="top-header".*(?=<div id="menu-container")' => '',
      'id="header"' => '',
      '<div class="fb-like".*(?=<p id="content-header")' => '',
      '<div class="emailprint".*?</div>' => '',
      '<div id="other".*(?=<div id="body-content")' => '',
      '<div id="footer-container".*(?=</body>)' => '</div></div>'
    },
    'tuoitre.vn' => {
      '<script.*?</script>' => '',
      '(?<=href=["\'])http://(?=tuoitre.vn(?!/App_Themes))' => '/sites?url=http://',
      '(?<=href=["\'])[.\/]*(?=(App_Themes|Images|Master))' => 'http://tuoitre.vn/',
      '(?<=url\()../(?=Images)' => 'http://tuoitre.vn/',
      '(?<=src=["\'])../(?=App_Themes)' => 'http://tuoitre.vn',
      '<div class="itemtop".*(?=<div id="header")' => '',
      '<div class="logo".*?</div>' => '',
      '(?<=<div id="header")' => ' style="background-image:none"',
      '<div class="boxQcTop".*?</style>' => '',
      '<div id="mnu_.*?<div class="clearFix"></div>' => '',
      '<div id="colunmRight".*<!-- STATISTIC -->' => '',
      '<div id="mnu".*?</div>' => '',
      '<li id="WebPart_Media".*?</li>' => '',
      '<div class="channelttopright".*(?=<div id="colunmLeft1")' => '</div></div>',
      '<div class="boxQcFullbtom".*(?=</form>)' => '</div>',
      '<div class="THTT".*?<div class="clearFix">' => '</div>',
      '(?<=<div class="channeltop")' => ' style="border: none"',
      '<div class="boxSearch".*?</div></div></div>' => '',
      '<div class="boxItemNextPage".*?<div class="clearfix"></div></div>' => '',
      '<div class="Head.*?(?=</div></form>)' => '</div></div>',
      '<div class="xemtiep".*?</div>' => '',
      '<div id="colunmRight".*(?=</form>)' => '</div></div>',
      '<div class="rptbottomtool".*(?=<!-- CAC TIN BAI KHAC -->)' => ''
    },
    'vietnamnet.vn' => {
      '(?<=href=["\'])/' => '/sites?url=http://vietnamnet.vn/',
      '<div class="topPage".*(?=<div class="menuTopBox")' => '',
      '<a class="logoPage".*?</a>' => '',
      '(?<=<div class="menuTopBoxContentInside")' => ' style="margin-left: 0"',
      '<div class="updateTimeBox".*?</div>' => '',
      '<div class="hotlinevnn".*?(?=<script)' => '',
      '<div class="right grey margin-top-5".*?(?=</div><div class="articleDetailBox")' => '',
      '<div comment2.*?(?=<div class="padding-10")' => '',
      '<div class="columnsPageCenterRight clearfix".*?<!--\[bottomPage\]-->' => '</div></div></div></div>',
      '(?<=<div class="columnsPageLeft")' => ' style="width: 1000px"'
    },
    'vn.news.yahoo.com' => {
      '<script.*?</script>' => '',
      '<div id="header".*?(?=<div class="yom-mod yom-nav")' => '',
      '<footer>.*?</footer>' => ''
    },
    'vnexpress.net' => {
      '\/\/<!\[CDATA\[.*?\/\/\]\]>' => '',
      '<script.*?</script>' => '',
      '(?<=href=["\'])/(?=([Ll]ibrary|[Rr]esource|[Ii]mages|[Ff]iles))' => 'http://vnexpress.net/',
      '(?<=src=["\'])/(?=([Ll]ibrary|[Rr]esource|[Ii]mages|[Ff]iles))' => 'http://vnexpress.net/',
      '(?<=href=["\'])/' => '/sites?url=http://vnexpress.net/',
      '(?<=href=["\'])http://(?=vnexpress.net/(?!([Ll]ibrary|[Rr]esource|[Ii]mages|[Ff]iles)))' => '/sites?url=http://',
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