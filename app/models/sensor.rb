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
  has_many :sensor_readings


  # The following section needs to move to a controller or helper method
  # -----------------------------------------------------------
  # Add virtual attributes to JSON hash
  def as_json(options = { })
    super((options || { }).merge({
        :methods => [:current_hour_kwh_usage,
                     :current_day_kwh_usage,
                     :current_week_kwh_usage,
                     :last_7_day_kwh_usage_by_day,
                     :current_month_kwh_usage_by_day]
    }))
  end

  # Get the total kwh usage for the current hour
  def current_hour_kwh_usage
    total_hour_kwh_usage_on(Time.now.utc.to_date, Time.now.utc.hour).round(2)
  end

  # Get the total kwh usage for the current day
  def current_day_kwh_usage
    total_day_kwh_usage_on(Time.now.utc.to_date).round(2)
  end

  # Get the total kwh usage for the current week
  def current_week_kwh_usage
    total_week_kwh_usage_until(Time.now.utc.to_date).round(2)
  end

  # Get the kwh usage for each day for the last 7 days
  def last_7_day_kwh_usage_by_day
     usage_data = []
      Time.now.utc.to_date.downto(6.days.ago.utc.to_date).each do |date|
        usage_data << total_day_kwh_usage_on(date).round(2)
      end
      usage_data
  end

  # Get the kwh usage for each day for the current week
  def current_month_kwh_usage_by_day
    current_date = Time.now.utc.to_date
    num_days_until_yesterday = current_date.day - 1
    usage_data = []
      current_date.downto(num_days_until_yesterday.days.ago.utc.to_date).each do |date|
        usage_data << total_day_kwh_usage_on(date).round(2)
      end
      usage_data
  end

  # -----------------------------------------------------------

  # Calculate the total kwh usage for a given date (UTC) and hour (range = 0..23)
  def total_hour_kwh_usage_on(date, hour)
    raise "Invalid argument: Please use a non negative value for hour" if hour < 0
    raise "Invalid argument: Please use a value that is less than or equal to 23 for hour" if hour > 23

    lower = date + hour.hour
    upper = lower + 1.hour

    return 0.0 unless lower < Time.now.utc

    readings = self.sensor_readings.where(:created_at => lower..upper)

    cumulative_watthours_usage = 0.0
    readings.each do |reading|
      cumulative_watthours_usage += reading.watthours
    end

    average_watthours_usage = cumulative_watthours_usage/60
    kwh_usage = average_watthours_usage/1000
    kwh_usage
  end

  # Calculate the total kwh usage for a given date (UTC)
  def total_day_kwh_usage_on(date)
    raise "Invalid argument: Please use a date value that is not in the future" if (date > Time.now.utc.to_date)

    cumulative_hourly_kwh_usage = 0.0
    (0..23).each do |i|
      cumulative_hourly_kwh_usage += self.total_hour_kwh_usage_on(date, i)
      #puts cumulative_hourly_kwh_usage.to_s
    end
    cumulative_hourly_kwh_usage
  end

  # Calculate the total kwh usage for the week until the specified date (UTC)
  def total_week_kwh_usage_until(date)
    raise "Invalid argument: Please use a date value that is not in the future" if (date > Time.now.utc.to_date)

    cumulative_daily_kwh_usage = 0.0
    (0..date.wday).each do |i|
      cumulative_daily_kwh_usage += self.total_day_kwh_usage_on(date - i.day)
    end
    cumulative_daily_kwh_usage
  end

  # Calculate the total kwh usage for the month until the specified date (UTC)
  def total_month_kwh_usage_until(date)
    raise "Invalid argument: Please use a date value that is not in the future" if (date > Time.now.utc.to_date)

    cumulative_daily_kwh_usage = 0.0
    (1..date.day).each do |i|
      cumulative_daily_kwh_usage += self.total_day_kwh_usage_on(date - i.day)
    end
    cumulative_daily_kwh_usage
  end
end
