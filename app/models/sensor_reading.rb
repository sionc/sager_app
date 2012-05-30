class SensorReading < ActiveRecord::Base
  attr_accessible :sensor_id, :watthours, :sensor_local_id, :created_at
  #
  # Associations
  #
  belongs_to :sensor, :foreign_key => :sensor_local_id, :primary_key => :local_id
  validates_presence_of :sensor
end
