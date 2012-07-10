class Sensor < ActiveRecord::Base
  attr_accessor :is_scheduled_to_be_off
  attr_accessible :user_id, :mac_address, :label, :enabled, :plus

  #
  # Validations
  #
  validates_presence_of :mac_address
  validates_uniqueness_of :mac_address
  validates_presence_of :user

  #
  # Associations
  #
  belongs_to :user
  has_many :sensor_readings
  has_many :schedules


  # The following section needs to move to a controller or helper method
  # -----------------------------------------------------------
  # Add virtual attributes to JSON hash
  def as_json(options = { })
    super((options || { }).merge({
        :methods => [:current_month_kwh_usage_by_day]
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

    connection = ActiveRecord::Base.connection()
    pgresult = connection.execute(
      "SELECT SUM(watthours)
        FROM sensor_readings
        WHERE sensor_id = #{id}
        AND created_at BETWEEN '#{lower}' and '#{upper}'")
    output = pgresult.nil? ? 0.0 : (pgresult[0].values[0].to_f)/60/1000
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

  # Is the sensor scheduled to be off?
  def is_scheduled_to_be_off
    offset_to_pdt = -25200
    current_time = Time.now.utc + offset_to_pdt
    current_time_minutes = (current_time.hour * 60) + current_time.min
    self.schedules.each do |schedule|
      return true if (current_time_minutes > schedule.start_time) && (current_time_minutes < schedule.end_time)
    end
    false
  end
end
