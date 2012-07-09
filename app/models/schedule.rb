class Schedule < ActiveRecord::Base
  attr_accessible :end_time, :sensor_id, :start_time

  #
  # Validations
  #
  validates_presence_of :sensor_id
  validates_presence_of :start_time
  validates_presence_of :end_time

  #
  # Associations
  #
  belongs_to :sensor
end
