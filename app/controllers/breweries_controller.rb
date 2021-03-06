class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :skip_if_cached, only: [:index]

  # GET /breweries
  # GET /breweries.json
  def index
    @breweries = Brewery.all
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired


    order = params[:order] || 'name'

    if order == 'name'
      @active_breweries = @active_breweries.sort_by{ |b| b.name }
      @retired_breweries = @retired_breweries.sort_by{ |b| b.name }
    elsif order == 'year'
      if session[:list_ord]
        @active_breweries = @active_breweries.sort_by{ |b| b.year }.reverse
        @retired_breweries = @retired_breweries.sort_by{ |b| b.year }.reverse
        session[:list_ord] = false
      else
        @active_breweries = @active_breweries.sort_by{ |b| b.year }
        @retired_breweries = @retired_breweries.sort_by{ |b| b.year }
        session[:list_ord] = true
      end
    end
  end

  def list
  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    expire_frags
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    expire_frags
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    expire_frags
    if is_admin
      @brewery.destroy
      respond_to do |format|
        format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to beer_clubs_url, notice: 'Only admins can do that!' }
        format.json { head :no_content }
      end
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end

  def skip_if_cached
    @order = params[:order] || 'name'
    return render :index if fragment_exist?( "brewerylist-#{@order}"  )
  end

  private

    def expire_frags
      ["brewerylist-name", "breweylist-year"].each{ |f| expire_fragment(f) }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def authenticate
      admin_accounts = { "admin" => "secret", "pekka" => "beer", "arto" => "foobar", "matti" => "ittam"}
      authenticate_or_request_with_http_basic do |username, password|
        admin_accounts.has_key?(username) and admin_accounts[username] = password
      end
    end
end
