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
      '(?<=href=["\'])/' => 'http://ngoisao.net/',
      '(?<=src=["\'])/' => 'http://ngoisao.net/',
      '(?<=</head>).*?<div class="detailCT"' => '<body style="background: none"><div',
      '<div class="detailNS".*' => '</div></body>',
      '<div class="topDetail".*?(?=<[Hh]1)' => '',
    },
    'tiin.vn' => {
      '<script.*?</script>' => '',
      '.*?(?=<div id="left-content-container")' => '',
      '<div id="tag-container".*' => '</div>',
      '<div id="breadcrumb-container".*?(?=<div id="body-content")' => '',
      '<ul id="related-link-container".*?</ul>' => ''
    },
    'tuoitre.vn' => {
      '<script.*?</script>' => '',
      '(?<=href=["\'])[.\/]*(?=(App_Themes|Images|Master))' => 'http://tuoitre.vn/',
      '(?<=url\()../(?=Images)' => 'http://tuoitre.vn/',
      '(?<=src=["\'])../(?=App_Themes)' => 'http://tuoitre.vn',
      '(?<=</head>).*?<!-- MAIN CONTENT -->' => '<body>',
      '<!--.*' => '</body>'
    },
    'vietnamnet.vn' => {
      '<script.*?</script>' => '',
      '(?<=</head>).*?(?=<div class="articleDetailBox")' => '<body>',
      '<div comment2="true".*' => '</body>'
    },
    'vn.news.yahoo.com' => {
      '<script.*?</script>' => '',
      '(?<=</head>).*?(?=<div class="yog-wrap yog-grid yog-24u")' => '<body>',
      '<div class="yom-mod yom-ib-list" id="mediainfinitebrowselisttemp".*' => '</div></div></body>',
      '(?<=</h1>).*?(?=</div>)' => '',
      '<div class="yom-mod social-buttons".*?(?=<div class="yom-mod yom-art-content)' => ''
    },
    'vnexpress.net' => {
      '\/\/<!\[CDATA\[.*?\/\/\]\]>' => '',
      '<script.*?</script>' => '',
      '(?<=href=["\'])/' => 'http://vnexpress.net/',
      '(?<=src=["\'])/' => 'http://vnexpress.net/',
      '(?<=</head>).*?(?=<div class="content")' => '<body>',
      '<div class="likesubject fl".*' => '</div></body>'
    }
  }
end