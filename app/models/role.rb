class Role < ActiveRecord::Base
  attr_accessible :name

  #
  # Associations
  #
  has_and_belongs_to_many :users
end
