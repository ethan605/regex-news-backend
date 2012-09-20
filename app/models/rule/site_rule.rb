module Rule::SiteRule
  extend ActiveSupport::Concern

  HOME_INDEX = {
    'vnexpress.net' => {
      'top-news' => {
        'main' => {
          'url' => {
            'image' => '',
            'spoiler' => '',
            'title' => ''
          }
        },
        'sub' => [
        ],
        'other' => [
        ]
      },
      'categories' => [
        'Xã hội' => {
          'main' => '',
          'sub' => '',
          'other' => ''
        }
      ]
    }
  }
end