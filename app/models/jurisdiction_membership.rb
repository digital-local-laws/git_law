class JurisdictionMembership < ActiveRecord::Base
  belongs_to :jurisdiction, inverse_of: :jurisdiction_memberships
  belongs_to :user, inverse_of: :jurisdiction_memberships

  validates :jurisdiction, presence: true
  validates :user, presence: true
end
