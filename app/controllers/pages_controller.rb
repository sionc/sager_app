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

  def start
    respond_to do |format|
      if user_signed_in?
        format.html { redirect_to sensors_path }
      else
        format.html
      end
    end
  end
end
