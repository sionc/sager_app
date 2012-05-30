class PagesController < ApplicationController
  def home
    hub = Hub.find_by_mac_address("01:23:45:67:89:ab")
    @sensors = hub.sensors unless hub.nil?
  end

  def help
  end
end
