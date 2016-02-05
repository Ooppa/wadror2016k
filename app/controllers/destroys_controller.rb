class DestroysController < ApplicationController
  before_action :set_destroy, only: [:show, :edit, :update, :destroy]

  # GET /destroys
  # GET /destroys.json
  def index
    @destroys = Destroy.all
  end

  # GET /destroys/1
  # GET /destroys/1.json
  def show
  end

  # GET /destroys/new
  def new
    @destroy = Destroy.new
  end

  # GET /destroys/1/edit
  def edit
  end

  # POST /destroys
  # POST /destroys.json
  def create
    @destroy = Destroy.new(destroy_params)

    respond_to do |format|
      if @destroy.save
        format.html { redirect_to @destroy, notice: 'Destroy was successfully created.' }
        format.json { render :show, status: :created, location: @destroy }
      else
        format.html { render :new }
        format.json { render json: @destroy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /destroys/1
  # PATCH/PUT /destroys/1.json
  def update
    respond_to do |format|
      if @destroy.update(destroy_params)
        format.html { redirect_to @destroy, notice: 'Destroy was successfully updated.' }
        format.json { render :show, status: :ok, location: @destroy }
      else
        format.html { render :edit }
        format.json { render json: @destroy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /destroys/1
  # DELETE /destroys/1.json
  def destroy
    @destroy.destroy
    respond_to do |format|
      format.html { redirect_to destroys_url, notice: 'Destroy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_destroy
      @destroy = Destroy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def destroy_params
      params.require(:destroy).permit(:membership)
    end
end
