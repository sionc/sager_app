class PagesController < ApplicationController
  #
  # Devise
  #
  before_filter :authenticate_user!, :except => [:start, :about]

  def home
  end

  def about
  end

  def trends
  end

  def dashboard
    # TODO: double-check that the authorization is working as intended
    # we're not using load_and_authorize_resource here
    # I just have to remember what the heck that does :)
    @sensors = Sensor.accessible_by(current_ability)
  end

  def start
    respond_to do |format|
      if user_signed_in?
        format.html { redirect_to pages_dashboard_path }
      else
        format.html
      end
    end
  end
end
