class SitesController < ApplicationController
  def index
    @content = Rule.apply_rules(params[:url])

    unless @content
      @sites = []
      Rule.each do |r|
        @sites << r.domain
      end
    end

    respond_to do |format|
      format.html   #index.html.erb
    end
  end
end
