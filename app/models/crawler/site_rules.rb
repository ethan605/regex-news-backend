module Crawler::SiteRules
  extend ActiveSupport::Concern

  SITE_RULES = {
    'dantri.com.vn' => {
      title: 'Dan Tri',
      categories: {
        urls: {
          'Su Kien' => '/c728/sukien.htm',
          'Xa Hoi' => '/c20/xahoi.htm',
          'The Gioi' => '/c36/thegioi.htm',
          'The Thao' => '/c26/thethao.htm',
          'Giao Duc' => '/c25/giaoduc.htm',
          'Nhan Ai' => '/c167/tamlongnhanai.htm',
          'Kinh Doanh' => '/c76/kinhdoanh.htm',
          'Van Hoa' => '/c730/vanhoa.htm',
          'Giai Tri' => '/c23/giaitri.htm',
          'Phap Luat' => '/c170/skphapluat.htm',
          'Nhip Song Tre' => '/c135/nhipsongtre.htm',
          'Tinh Yeu' => '/c130/tinhyeu-gioitinh.htm',
          'Suc Khoe' => '/c7/suckhoe.htm',
          'Suc Manh So' => '/c119/sucmanhso.htm',
          'Oto Xe May' => '/c111/otoxemay.htm',
          'Chuyen La' => '/c132/chuyenla.htm',
          'Ban Doc' => '/c202/diendanbandoc.htm'
        },
        selectors: [
          '.mt3.clearfix'
        ],
        rules: {
          url: { '.mr1 > a' => '(?<=href=")[^>"]*' },
          title: { '.mr1 > a' => '(?<=>)[\w[^<]]+' },
          image: { 'a > img' => '(?<=src=")[^>"]*' },
          spoiler: { '.fon5' => '(?<=>)[\w[^<]]+' }
        }
      }
    },
    'kenh14.vn' => {
      title: 'Kenh 14',
      categories: {
        urls: {
          'Star' => [
            '/star.chn',
            '/star/sao-viet.chn',
            '/star/paparazzi.chn'
          ],
          'Musik' => [
            '/musik.chn',
            '/musik/au-my.chn',
            '/musik/chau-a.chn',
            '/musik/viet-nam.chn'
          ],
          'Cine' => [
            '/cine.chn',
            '/cine/mot-phim.chn',
            '/cine/phim-viet-nam.chn',
            '/cine/phim-au-my.chn',
            '/cine/phim-chau-a.chn',
          ],
          'Fashion' => [
            '/fashion.chn',
            '/fashion/mot-14.chn',
            '/fashion/xu-huong.chn',
            '/fashion/teenlook.chn',
            '/fashion/mix-do.chn',
            '/fashion/star-style.chn',
            '/fashion/connect-4u.chn'
          ],
          'Doi Song' => [
            '/doi-song.chn',
            '/doi-song/xa-hoi.chn',
            '/doi-song/nhan-vat.chn',
            '/doi-song/quan-xa.chn',
            '/doi-song/cau-chuyen-that.chn',
            '/xem-an-choi.chn'
          ],
          'Gioi Tinh' => [
            '/gioi-tinh.chn',
            '/gioi-tinh/kien-thuc-gioi-tinh.chn',
            '/gioi-tinh/dep.chn'
          ],
          'Made By Teens' => [
            '/made-by-teens.chn',
            '/made-by-teens/handmade.chn',
            '/made-by-teens/kitchen.chn',
            '/made-by-teens/meo-vat.chn'
          ],
          'La' => '/la.chn',
          'Sport' => [
            '/sport.chn',
            '/sport/bong-da.chn',
            '/sport/sport-video.chn',
            '/sport/anh.chn',
            '/sport/ben-le-san-dau.chn'
          ],
          'Teeniscover' => [
            '/teeniscover.chn',
            '/teeniscover/khoa-hoc-cong-nghe.chn',
            '/teeniscover/lich-su-van-hoa.chn',
            '/teeniscover/thien-nhien-ky-thu.chn',
            '/teeniscover/thuc-hanh.chn'
          ],
          '2 Tek' => [
            '/2-tek.chn',
            '/2-tek/cong-nghe-vui.chn',
            '/2-tek/thu-thuat.chn',
            '/2-tek/san-pham-moi.chn'
          ],
          'Goc Trai Tim' => [
            '/goc-trai-tim.chn',
            '/goc-trai-tim/trai-tim-co-nang.chn',
            '/goc-trai-tim/teen-story.chn'
          ],
          'Hoc Duong' => [
            '/hoc-duong.chn',
            '/hoc-duong/du-hoc.chn',
            '/hoc-duong/ban-tin-46.chn'
          ]
        },
        selectors: [
          '.listnews .item.clearfix',
          '.featurewrapper.clearfix'
        ],
        rules: {
          url: { '.title a' => '(?<=href=")[^"]*' },
          title: { '.title a' => '(?<=>)[^<]*' },
          image: { '.img a img' => '(?<=src=")[^"]*' },
          spoiler: { '.sapo' => '(?<=>)[^<]*' }
        }
      }
    },
    'ngoisao.net' => {
      title: 'Ngoi Sao',
      categories: {
        urls: {
          'Hau Truong' => [
            '/tin-tuc/hau-truong',
            '/tin-tuc/showbiz-viet',
            '/tin-tuc/chau-a',
            '/tin-tuc/hollywood',
          ],
          'The Thao' => [
            '/tin-tuc/ben-le/',
            '/tin-tuc/the-thao/clip/',
            '/tin-tuc/the-thao/khoe-dep/'
          ],
          'Thoi Cuoc' => [
            '/tin-tuc/24h',
            '/tin-tuc/chuyen-la/',
            '/tin-tuc/hinh-su/',
            '/tin-tuc/thuong-truong/'
          ],
          'Phong Cach' => [
            '/tin-tuc/thoi-trang/',
            '/tin-tuc/tam-tinh/',
            '/tin-tuc/lam-dep/',
            '/tin-tuc/trac-nghiem/'
          ],
          'Thu Gian' => [
            '/tin-tuc/an-choi-xem/',
            '/tin-tuc/dan-choi/',
            '/tin-tuc/cuoi/',
            '/tin-tuc/game/'
          ],
          'Goc Doc Gia' => [
            '/tin-tuc/choi-blog/',
            '/tin-tuc/thi-anh/',
            '/tin-tuc/miss/'
          ],
          'Cuoi' => [
            '/tin-tuc/co-dau/',
            '/tin-tuc/cam-nang/',
            '/tin-tuc/anh-cuoi/',
            '/tin-tuc/chia-se/',
            '/tin-tuc/binh-chon-anh-cuoi/'
          ]
        },
        selectors: [
          '.news li'
        ],
        rules: {
          url: { 'a.ptw' => '(?<=href=")[^>"]*' },
          title: { 'h3 > a' => '(?<=>)[\w[^\r\n<]]+' },
          image: { 'a > img' => '(?<=src=")[^>"]+' },
          spoiler: { 'p:nth-of-type(2)' => '(?<=<p>)[^<]+?(?=<)' }
        }
      }
    },
    'vnexpress.net' => {
      title: 'VnExpress',
      categories: {
        urls: {
          'Xa Hoi' => [
            '/gl/xa-hoi/giao-duc',
            '/gl/xa-hoi/nhip-dieu-tre',
            '/gl/doi-song/cau-chuyen-cuoc-song',
            '/gl/xa-hoi/du-lich',
            '/gl/xa-hoi/co-hoi-du-hoc'
          ],
          'The Gioi' => [
            '/gl/the-gioi/cuoc-song-do-day',
            '/gl/the-gioi/anh',
            '/gl/the-gioi/nguoi-viet-5-chau',
            '/gl/the-gioi/phan-tich',
            '/gl/the-gioi/tu-lieu',
            '/gl/the-gioi/bau-cu'
          ],
          'Kinh Doanh' => [
            '/gl/kinh-doanh/bat-dong-san',
            '/gl/kinh-doanh/kinh-nghiem',
            '/gl/kinh-doanh/quoc-te',
            '/gl/doi-song/mua-sam',
            '/gl/kinh-doanh/doanh-nghiep-viet'
          ],
          'Phap Luat' => [
            '/gl/phap-luat/hinh-su',
            '/gl/phap-luat/ky-su',
            '/gl/phap-luat/tu-van'
          ],
          'Gia Dinh - Suc Khoe' => [
            '/gl/suc-khoe',
            '/gl/doi-song/gia-dinh',
            '/gl/suc-khoe/gioi-tinh',
            '/gl/doi-song/me-va-be',
            '/gl/doi-song/am-thuc',
            '/gl/doi-song/meo-vat',
            '/gl/doi-song/album',
            '/gl/suc-khoe/lam-dep'
          ],
          'Khoa Hoc' => [
            '/gl/khoa-hoc/moi-truong',
            '/gl/khoa-hoc/thien-nhien',
            '/gl/khoa-hoc/anh',
            '/gl/khoa-hoc/ky-thuat-moi'
          ],
          'Oto - Xe May' => [
            '/gl/oto-xe-may/tu-van',
            '/gl/oto-xe-may/thi-truong'
          ],
          'Ban Doc Viet' => [
            '/gl/ban-doc-viet/anh',
            '/gl/ban-doc-viet/the-gioi',
            '/gl/ban-doc-viet/van-hoa',
            '/gl/ban-doc-viet/the-thao',
            '/gl/ban-doc-viet/kinh-doanh',
            '/gl/ban-doc-viet/xa-hoi',
            '/gl/ban-doc-viet/phap-luat',
            '/gl/ban-doc-viet/doi-song',
            '/gl/ban-doc-viet/khoa-hoc'
          ],
          'Tam Su' => '/gl/ban-doc-viet/tam-su',
          'Cuoi' => [
            '/gl/cuoi/anh',
            '/gl/cuoi/tieu-pham'
          ]
        },
        selectors: [
          '#content .folder-top',
          '#content .folder-news'
        ],
        rules: {
          url: { 'a' => '(?<=href=")[^>"]*' },
          title: { 'p > a' => '(?<=>)[\w[^\r\n<]]+' },
          image: { 'a > img' => '(?<=src=")[^>"]+' },
          spoiler: { 'p:nth-of-type(2)' => '(?<=<p>)[^<]+?(?=<)' }
        }
      }
    }
  }
end