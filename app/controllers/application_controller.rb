class ApplicationController < ActionController::Base
  protect_from_forgery

  def doc
    str = File.open("#{Rails.root}/Readme.md").read
    # str.gsub!(/\/api\/.+/) do |match|
    #   "[`#{match}`](#{replace_param_placehoders(match)})"
    # end
    str = BlueCloth.new(str).to_html
    str = <<-HTML
      <html lang="en">
        <head>
          <title>Upendo API</title>
          <link href="/assets/bootstrap/bootstrap.css" rel="stylesheet">
        </head>
        <body>
          <div class="container">
            #{str}
          </div>
        </body>
      </html>
    HTML
    render text: str.html_safe
  end
end
