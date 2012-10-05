module Rule::ArticleRuleLite
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
      '.*(?=<div class="boxBaiViet-c")' => '',
      '<div class="boxDon-sub-b"></div><div class="center-Banner".*' => '',
      '<div class="baivietMainBox-img200".*?(?=<div class="baiviet-TopContent200")' => '',
      '<div class="publication_date".*?<div class="clear">' => '',
      '<div id="comment_content">.*' => '',
      '<div class="shareFB-green".*(?=</div></div>)' => ''
    },
    'bongdaplus.vn' => {
      '<script.*?</script>' => '',
      '(?<==["\'])\s*/' => 'http://bongdaplus.vn/',
      '.*(?=<div class="article alpha")' => '',
      '<div class="social clearfix".*' => '',
      '<div class="date".*?(?=<div class="sapo")' => '',
      '<p class="like".*?</p>' => '',
      '<div class="tag".*?</div>' => ''
    },
    'dantri.com.vn' => {
      '<script.*?</script>' => '',
      '(?<=href=["\'])/' => 'http://dantri.com.vn/',
      '.*(?=<div id="ctl00_IDContent_ctl00_divContent")' => '',
      '(?<=<div id="ctl00_IDContent_ctl00_divContent">).*?</p>' => '',
      '<div itemscope.*' => '</div>',
      'h2' => 'p'
    },
    'kenh14.vn' => {
      '<script.*?</script>' => '',
      '.*(?=<div class="postpadding")' => '',
      '<div class="clearfix".*' => '',
      '<div class="breadcrumb".*?</div>' => '',
      '<div class="meta".*?(?=<p class="sapo")' => ''
    },
    'news.zing.vn' => {
      '<script.*?</script>' => '',
      '.*(?=<div class="znews_leftcol")' => '',
      '<!-- end: left column -->.*' => '',
      '<div id="content_head".*?(?=<div class="newsdetail_wrapper")' => '',
      '<ul class="share_buttons".*' => '</div></div>'
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