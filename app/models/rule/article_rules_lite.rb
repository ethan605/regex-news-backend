module Rule::ArticleRulesLite
  extend ActiveSupport::Concern

  CHANGE_ELEMENTS_LITE = {
    '24h.com.vn' => {
      '\/\/<!\[CDATA\[.*?\/\/\]\]>' => '',
      '<script.*?</script>' => '',
      '(?<==["\'])\s*/' => 'http://www.24h.com.vn/',
      '(?<=</head>).*?(?=<div class="boxBaiViet-c")' => '<body>',
      '<div class="boxDon-sub-b"></div><div class="center-Banner".*' => '</body>',
      '<div class="baivietMainBox-img200".*?(?=<div class="baiviet-TopContent200")' => '',
      '(?<=<div class="baiviet-TopContent200")' => ' style="width: 100%"',
      '(?<=<div class="boxBaiViet-c")' => ' style="width: 100%; background: none"',
      '<div class="cap2-boxtop-note".*?(?=<div class="clear")' => '</div>',
      '<div class="shareFB-green".*' => '</div></div></body>'
    },
    'bongdaplus.vn' => {
      '<script.*?</script>' => '',
      '(?<==["\'])\s*/' => 'http://bongdaplus.vn/',
      '(?<=</head>).*?(?=<div class="article alpha")' => '<body>',
      '<div class="social clearfix".*' => '</body>',
      '<div class="fontsize".*?</div>' => '',
      '<p class="like".*?</p>' => '',
      '<div class="tag".*?</div>' => ''
    },
    'dantri.com.vn' => {
      '<script.*?</script>' => '',
      '(?<=href=["\'])/' => 'http://dantri.com.vn/',
      '(?<=</head>).*?(?=<div id="ctl00_IDContent_ctl00_divContent")' => '<body style="background: none">',
      '<div itemscope.*' => '</div></body>',
      '<div class="box26".*?</div>' => ''
    },
    'kenh14.vn' => {
      '<script.*?</script>' => '',
      '(?<=</head>).*?(?=<div class="postwrapper clearfix")' => '<body>',
      '<div class="clearfix".*' => '</body>',
      '<div class="breadcrumb".*?</div>' => '',
      '<div class="meta".*?(?=<p class="sapo")' => '',
      '(?<=<div class="postwrapper clearfix")' => ' style="width: 100%"'
    },
    'news.zing.vn' => {
      '<script.*?</script>' => '',
      '(?<=</head>).*?(?=<div class="znews_leftcol")' => '<body>',
      '<!-- end: left column -->.*' => '</body>',
      '<div class="subheader".*?</div>' => '',
      '<div id="detail_sidebar".*?(?=<div class="newsdetail_wrapper")' => '',
      '<ul class="share_buttons".*' => '</div></div></body>',
      '(?<=<div class="znews_leftcol")' => ' style="width: 100%"',
      '(?<=<div class="newsdetail_wrapper" id="content_document")' => ' style="width: 100%; padding: 0;"'
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
      '(?<=</head>).*?(?=<div id="body-content")' => '<body style="background: none">',
      '(?<=<div id="body-content")' => ' style="width: 100%"',
      '<div id="tag-container".*' => '</div></body>',
      '<div class="fb-like".*?</div>' => '',
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