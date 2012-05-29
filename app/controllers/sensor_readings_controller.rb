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

  # GET /sensor_readings/new
  # GET /sensor_readings/new.json
  # def new
  #   @sensor_reading = SensorReading.new

  #     respond_to do |format|
  #       format.html # new.html.erb
  #       format.json { render json: @sensor_reading }
  #     end
  #   end

  # GET /sensor_readings/1/edit
  # def edit
  #   @sensor_reading = SensorReading.find(params[:id])
  # end

  # POST /sensor_readings
  # POST /sensor_readings.json
  def create
    @sensor_reading = SensorReading.new(params[:sensor_reading])

    respond_to do |format|
      if @sensor_reading.save
        format.html { redirect_to @sensor_reading, notice: 'Sensor reading was successfully created.' }
        format.json { render json: @sensor_reading, status: :created, location: @sensor_reading }
      else
        format.html { render action: "new" }
        format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sensor_readings/1
  # PUT /sensor_readings/1.json
  # def update
  #   @sensor_reading = SensorReading.find(params[:id])

  # respond_to do |format|
  #   if @sensor_reading.update_attributes(params[:sensor_reading])
  #     format.html { redirect_to @sensor_reading, notice: 'Sensor reading was successfully updated.' }
  #     format.json { head :no_content }
  #   else
  #     format.html { render action: "edit" }
  #     format.json { render json: @sensor_reading.errors, status: :unprocessable_entity }
  #   end
  # end
  # end

  # DELETE /sensor_readings/1
  # DELETE /sensor_readings/1.json
  # def destroy
  #   @sensor_reading = SensorReading.find(params[:id])
  #   @sensor_reading.destroy

  #   respond_to do |format|
  #     format.html { redirect_to sensor_readings_url }
  #     format.json { head :no_content }
  #   end
  # end
end
