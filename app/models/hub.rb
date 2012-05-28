class Hub < ActiveRecord::Base
  attr_accessible :mac_address, :user_id

  #
  # Associations
  #
  belongs_to :user
  validates_presence_of :user
  has_many :sensor

  #
  # Validations
  #
  validates_presence_of :mac_address, :user_id
  validates_uniqueness_of :mac_address, :user_id

  # we'll standardize on mac address representation when we get there
  validates :mac_address, :length => { :maximum => 128 }
end
