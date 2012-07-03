class SensorReading < ActiveRecord::Base
  attr_accessible :sensor_id, :watthours, :created_at
  #
  # Associations
  #
  belongs_to :sensor
  validates_presence_of :sensor
end
