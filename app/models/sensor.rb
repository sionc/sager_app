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
end
