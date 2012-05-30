class SensorReadingsController < ApplicationController
  #
  # Devise
  #
  before_filter :authenticate_user!, :except => [:create]

  # GET /sensor_readings
  # GET /sensor_readings.json
  def index
    @sensor_readings = SensorReading.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sensor_readings }
    end
  end

  # GET /sensor_readings/1
  # GET /sensor_readings/1.json
  def show
    @sensor_reading = SensorReading.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sensor_reading }
    end
  end

  # POST /sensor_readings
  # POST /sensor_readings.json
  def create
    # This whole logic feels poorly eloquent, I'll research a more succint approach
    @sensor_reading = SensorReading.new

    # input validation
    unless(params[:sensor_reading][:mac_address].nil? ||
           params[:sensor_reading][:local_id].nil? ||
           params[:sensor_reading][:watthours].nil?)
      logger.debug 'input valid!'
      logger.debug "Params hash: #{params.inspect}"

      # given the mac address, we can find the hub
      hub = Hub.find_by_mac_address(params[:sensor_reading][:mac_address])
      logger.debug "hub attributes: #{hub.attributes.inspect}"

      # given the hub, the local_id  can be used to identify a single sensor
      sensor = Sensor.find_by_hub_id_and_local_id hub.id, params[:sensor_reading][:local_id]
      logger.debug "sensor attributes: #{sensor.attributes.inspect}"

      # we then store the reading for that specific sensor
      @sensor_reading = SensorReading.new(:sensor_local_id => sensor.local_id,
                                          :watthours => params[:sensor_reading][:watthours])
      logger.debug "sensor_reading attributes: #{@sensor_reading.attributes.inspect}"
    end

    logger.debug 'past input valid'

    respond_to do |format|
      if @sensor_reading.save
        logger.debug "@sensor_reading saved succesfully"
        format.html { redirect_to @sensor_reading, notice: 'Sensor reading was successfully created.' }
        format.json { render json: @sensor_reading, status: :created, location: @sensor_reading }
      else
        logger.debug "@sensor_reading save failed"
        format.html { render action: "new" }
        format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
      end
    end
  end
end
