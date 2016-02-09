class AdoptedLaw < ActiveRecord::Base
  belongs_to :proposed_law, inverse_of: :adopted_law

  validates :proposed_law, presence: true

  attr_accessor :certification_type
end
