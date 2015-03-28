class ProposedLaw < ActiveRecord::Base
  belongs_to :code, inverse_of: :proposed_laws
  belongs_to :user, inverse_of: :proposed_laws
  
  validates :code, presence: true
  validates :user, presence: true
  validates :title, presence: true
end
