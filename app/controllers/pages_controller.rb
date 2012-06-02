class PagesController < ApplicationController
  #
  # Devise
  #
  before_filter :authenticate_user!

  def home
  end

  def about
  end

  def trends
  end

  # GET /pages/user_sensors.json
  def user_sensors
    @user_sensors = current_user.sensors

    respond_to do |format|
      format.json { render json: {:sensors => @user_sensors} }
    end
  end
end
