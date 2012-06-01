class PagesController < ApplicationController
  #
  # Devise
  #
  before_filter :authenticate_user!

  def home
    hub = Hub.find_by_mac_address("01:23:45:67:89:ab")
    @sensors = hub.sensors unless hub.nil?
  end

  def about
  end

  def trends
  end
end
