class Sensor < ActiveRecord::Base
  attr_accessible :hub_id, :name, :local_id

  #
  # Validations
  #
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:name, :hub_id]

  # This could be a waste of time given the already existing unique index on these two fields
  validates_uniqueness_of :local_id, :scope => [:local_id, :hub_id]

  #
  # Associations
  #
  belongs_to :hub
  validates_presence_of :hub
  has_many :sensor_readings, :foreign_key => :sensor_local_id, :primary_key => :local_id

  # Calculate the total kwh usage for a given date (UTC) and hour (range = 0..23)
  def hourly_kwh_usage_on(date, hour)
    raise "Invalid argument: Please use a non negative value for hour" if hour < 0
    raise "Invalid argument: Please use a value that is less than or equal to 23 for hour" if hour > 23

    lower = date + hour.hour
    upper = lower + 1.hour

    raise "Invalid argument: Please use a DateTime value that is not in the future" if (lower > Time.now.utc)

    readings = self.sensor_readings.where(:created_at => lower..upper)

    cumulative_watthours_usage = 0.0
    readings.each do |reading|
      cumulative_watthours_usage += reading.watthours
    end

    average_watthours_usage = cumulative_watthours_usage/60
    kwh_usage = average_watthours_usage/1000
  end

  # Calculate the total kwh usage for a given date (UTC)
  def daily_kwh_usage_on(date)
    raise "Invalid argument: Please use a date value that is not in the future" if (date > Time.now.utc.to_date)

    cumulative_hourly_kwh_usage = 0.0
    (0..23).each do |i|
      cumulative_hourly_kwh_usage += self.hourly_kwh_usage_on(date, i)
      #puts cumulative_hourly_kwh_usage.to_s
    end
    cumulative_hourly_kwh_usage
  end

  # Calculate the total kwh usage for the week until the specified date (UTC)
  def weekly_kwh_usage_until(date)
    raise "Invalid argument: Please use a date value that is not in the future" if (date > Time.now.utc.to_date)

    cumulative_daily_kwh_usage = 0.0
    (0..6).each do |i|
      cumulative_daily_kwh_usage += self.daily_kwh_usage_on(date - i.day)
    end
    cumulative_daily_kwh_usage
  end
end
