class SitesController < ApplicationController
  def index
    url_pattern = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

    if params[:url] && params[:url] =~ url_pattern
      @content = Rule.apply_rules(params[:url])
    else
      @content = nil
    end

    unless @content
      rules = Rule.all.order_by([:domain])
      @sites = []
      rules.each do |r|
        @sites << r.domain
      end
    end

    respond_to do |format|
      format.html   #index.html.erb
    end
  end

  def rules
    status = 0
    messages = ['', 'Authentication failed', 'No sites found']
    public_key = params[:key]
    auth = Auth.key(public_key).first

    if auth
      digest = OpenSSL::Digest::Digest.new('sha256')
      private_key = auth.private_key
      message = [request.path, request.method, params[:key], params[:params] ? params[:params] : ""]
      message = Auth.convert_params(message)
      hmac = OpenSSL::HMAC.hexdigest(digest, private_key.to_s, message)

      status = 1 unless params[:hmac] && hmac == params[:hmac]
    else
      status = 1
    end
    
    if status == 0
      sites = Rule.all.order_by([:domain])
      status = 2 if sites.count == 0
    end

    if status == 0
      render json: { status: status, sites: sites }
    else
      render json: { status: status, message: messages[status] }
    end
  end

  def home
    if (!params[:domain])
      render json: { status: 2, message: 'Invalid request' }
      return
    end

    site = Site.domain(params[:domain]).first

    if (!site)
      render json: { status: 0, results: [] }
      return
    end

    articles = []
    categories = site.categories.title(params[:category])
    categories.map do |cat|
      cat.articles.map { |article| articles << article }
    end

    render json: { status: 0, results: articles }
  end
end
