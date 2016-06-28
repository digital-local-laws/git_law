class AdoptedLaw < ActiveRecord::Base
  belongs_to :proposed_law, inverse_of: :adopted_law

  validates :adopted_on, presence: true
  validates :proposed_law, presence: true
  validates :executive_action, :executive_action_date, presence: true,
    if: :executive_jurisdiction?
  validates :referendum_type, presence: true, if: :referendum_required?
  validates :election_type, presence: true, if: :election_required?
  validates :permissive_petition, inclusion: { in: [ true, false ] },
    if: :permissive_referendum?
  validates :referendum_required, inclusion: { in: [ true, false ] }

  def executive_jurisdiction?
    return false unless proposed_law
    proposed_law.jurisdiction.executive_review?
  end

  def permissive_referendum?
    referendum_type && referendum_type == 'permissive'
  end

  def election_required?
    referendum_required? && ( !permissive_referendum? ||
    permissive_petition )
  end
end
