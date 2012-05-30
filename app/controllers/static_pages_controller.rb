class StaticPagesController < ApplicationController
  def home
    @sensors = Sensor.all
  end

  def help
  end
end
