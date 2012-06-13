class ApplicationController < ActionController::Base
  before_filter :check_uri
  protect_from_forgery

  # Redirection from naked domain to the www.-prepended version
  # Does not kick in if the app is running as rails server or spork
  def check_uri
    unless request.host == 'localhost' || request.host == 'test.host'
      redirect_to request.protocol + "www." + request.host_with_port +
        request.fullpath if !/^www/.match(request.host)
    end
  end
end
