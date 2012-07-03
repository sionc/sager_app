class User < ActiveRecord::Base
  #
  # Devise-generated settings
  #
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :demo
  # attr_accessible :title, :body

  #
  # Associations
  #
  has_many :sensors
  has_and_belongs_to_many :roles

  # fetches role of user
  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end
end
