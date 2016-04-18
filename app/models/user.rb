class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :confirmable, :omniauthable,
    omniauth_providers: [:developer]

  include DeviseTokenAuth::Concerns::User

  has_many :proposed_laws, inverse_of: :user, dependent: :restrict_with_error
  has_many :jurisdiction_memberships, inverse_of: :user
  has_many :jurisdictions, through: :jurisdiction_memberships

  accepts_nested_attributes_for :jurisdiction_memberships, allow_destroy: true,
    reject_if: :all_blank

  default_scope { order( :last_name, :first_name ) }

  scope :name_like, -> (name) {
    where( 'name ILIKE ?', "%#{name}%" )
  }

  validates :first_name, :last_name, :name, presence: true
  validates :email, presence: true

  before_validation :set_name
  before_save :set_name

  def token_validation_response
    self.as_json( except: [ "tokens", "created_at", "updated_at" ] )
      .merge( "permissions" => permissions )
  end

  def permissions
    { "jurisdiction" => {
        "adopt" => jurisdiction_memberships.where(adopt: true).
          pluck( :jurisdiction_id ),
        "propose" => jurisdiction_memberships.where(propose: true).
          pluck( :jurisdiction_id )
      }
    }
  end

  private

  def set_name
    self.name = "#{first_name} #{last_name}".strip.squeeze(' ')
  end
end
