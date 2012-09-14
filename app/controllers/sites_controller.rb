class SitesController < ApplicationController
  def index
    content = Rule.apply(params[:url])

    render json: content
  end
end
