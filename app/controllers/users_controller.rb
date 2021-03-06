class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_user_from_current_user, only: [:dashboard, :printout, :edit, :update, :destroy]

  before_action :authenticate_user!, only: [:dashboard, :printout, :edit, :update, :destroy]

  skip_before_action :redirect_if_logged_in, only: [:dashboard, :printout, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    guest_address = nil

    result = request.location
    latitude = result.data["latitude"].to_d
    longitude = result.data["longitude"].to_d

    if latitude != 0 && longitude != 0
      guest_address = "#{latitude},#{longitude}"
    end

    sorted_shelters = User.sorted_shelters(guest_address).reverse!
    unavailable = User.where(full: true).all.map { |u| [u, nil] } # nil dist, don't matter
    @users_with_distances = sorted_shelters + unavailable
  end

  def dashboard
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def donate_success
  end

  def printout
    @qr = RQRCode::QRCode.new( polymorphic_url([@user]), :size => 10, :level => :h )

    render 'printout', layout: false
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        if @user.full
          @user.notify_guests_of_full_occupancy
        end
        format.html { redirect_to polymorphic_path [:dashboard, @user], notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_user_from_current_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :address, :phone, :full, :size)
    end
end
