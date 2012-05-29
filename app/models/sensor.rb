class Sensor < ActiveRecord::Base
  attr_accessible :hub_id, :name

  #
  # Validations
  #
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:name, :hub_id]

  #
  # Associations
  #
  belongs_to :hub
  validates_presence_of :hub
  has_many :sensor_readings
end
