class SitesController < ApplicationController
  def index
    @content = Rule.apply(params[:url])

    respond_to do |format|
      format.html
    end
  end
end
