class UrlsController < ApplicationController
  def index
    @url = Url.new()
    render :index
  end

  def create
    @url = Url.new(long_url: params[:long_url])
    if @url.is_duplicate?
      @url = @url.duplicate
      flash.now[:notice] = "shortend URL already exits!"
    elsif @url.save
      flash.now[:success] = "url shortend successfully!"
    else
      flash.now[:errors] = @url.errors.full_messages.join(" ")
      render :index
      return
    end
    render :show
  end

  def show
    @url = Url.find_by_id(params[:id])
    if !@url
      flash.now[:error] = "Record does not exists!"
      redirect_to action: :index
      return
    end
    render :show
  end

  def redirect
    url = Url.find_by_short_url(params[:short_url])
    if url.nil?
      flash.now[:error] = "Sorry no URL found!"
      redirect_to action: :index
      return
    end
    ClickStat.create(url_id: url.id,referer_url: request.referer)
    redirect_to url.sanitize_url
  end

  def url_stats
    type = params[:url_type]
    url = case type
    when "long"
      sanitized_url = Url.new(long_url: params[:url]).sanitize_url
      Url.find_by_sanitize_url(sanitized_url)
    when "short"
      Url.find_by_short_url(params[:url])
    else
      nil
    end
    if !url
      render json: {response: "failure",message:"No record found"}.to_json
      return
    end
    stats = url.click_stats
    response_hash = {
      response: "success",
      original_url: url.long_url,
      total_clicks: stats.count,
      click_stats: stats.map do |st|
                      {click_source: st.referer_url,
                        clicked_at: st.created_at.strftime('%d %b %Y %I:%M:%S %p %z')
                      }
                    end
      }
      render json: response_hash.to_json
  end
end
