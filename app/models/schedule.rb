class Schedule < ActiveRecord::Base
  attr_accessible :end_time, :sensor_id, :start_time
end
