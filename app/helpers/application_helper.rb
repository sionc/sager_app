module ApplicationHelper

# Methods to access the user resource in a non-devise controller
  def brand_name
    'PolarMeter'
  end

  def dollars_per_kwh
    0.11
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
