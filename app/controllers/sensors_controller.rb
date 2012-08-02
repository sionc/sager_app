class SensorsController < ApplicationController

  #
  # Devise
  #
  before_filter :authenticate_user!, :except => [:index, :update]

  #
  # CanCan
  #
  load_and_authorize_resource
  skip_authorize_resource :only => [:index, :update]

  # GET /sensors
  # GET /sensors.json
  def index
    # I don't envision passing the mac address at this point, instead some kind
    # of unique user identifier. This is a workaround for now.
    @sensors = Sensor.all

    @sensors.each do |sensor|
      sensor.enabled = 0 if sensor.is_scheduled_to_be_off
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {:sensors => @sensors} }
    end
  end

  # GET /sensors/1
  # GET /sensors/1.json
  def show
    @sensor = Sensor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sensor }
    end
  end

  # GET /sensors/new
  # GET /sensors/new.json
  def new
    @sensor = Sensor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sensor }
    end
  end

  # GET /sensors/1/edit
  def edit
    @sensor = Sensor.find(params[:id])
  end

  # POST /sensors
  # POST /sensors.json
  def create
    @sensor = Sensor.new(params[:sensor])
    @sensor.user_id = current_user.id
    @sensor.enabled = true

    # the form will pass the last 6 alphanumerics by default since the first 10
    # are always identical and do not need to be specified by the user
    if(!@sensor.mac_address.nil?)
      @sensor.mac_address = "000D6F0000" + @sensor.mac_address
    end

    respond_to do |format|
      if @sensor.save
        format.html { redirect_to root_path, notice: 'Sensor was successfully created.' }
        format.json { render json: @sensor, status: :created, location: @sensor }
      else
        format.html { render action: "new" }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sensors/1
  # PUT /sensors/1.json
  def update
    @sensor = Sensor.find(params[:id])

    respond_to do |format|
      if @sensor.update_attributes(params[:sensor])
        format.html { redirect_to @sensor, notice: 'Sensor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensors/1
  # DELETE /sensors/1.json
  def destroy
    @sensor = Sensor.find(params[:id])
    @sensor.destroy

    respond_to do |format|
      format.html { redirect_to sensors_url }
      format.json { head :no_content }
    end
  end

  # GETs the kWh usage for each day of the current month
  def get_current_month_kwh_usage
    sensor = Sensor.find(params[:sensor_id])
    current_month_kwh_usage_by_day = nil
    current_month_kwh_usage_by_day = sensor.current_month_kwh_usage_by_day unless sensor.nil?
    current_month_kwh_usage = 0

    unless current_month_kwh_usage_by_day.nil?
      current_month_kwh_usage_by_day.each do |usage|
         current_month_kwh_usage = current_month_kwh_usage + usage
      end
    end

    respond_to do |format|
      format.json { render json: {:current_month_kwh_usage => current_month_kwh_usage } }
    end
  end
end
