class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :confirmable, :omniauthable,
    omniauth_providers: [:developer]

  include DeviseTokenAuth::Concerns::User

  has_many :proposed_laws, inverse_of: :user, dependent: :restrict_with_error
  has_many :jurisdiction_memberships, inverse_of: :user
  has_many :jurisdictions, through: :jurisdiction_memberships

  validates :email, presence: true
end
