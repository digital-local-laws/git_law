class User < ActiveRecord::Base
  has_many :proposed_laws, inverse_of: :user, dependent: :restrict_with_error
  
  validates :email, presence: true
end
