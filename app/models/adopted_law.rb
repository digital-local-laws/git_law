class AdoptedLaw < ActiveRecord::Base
  EXECUTIVE_ACTIONS = [
    'approved',
    'allowed',
    'rejected'
  ]
  REFERENDUM_TYPES = [
    'mandatory',
    'permissive',
    'city charter revision',
    'county charter adoption'
  ]
  ELECTION_TYPES = [
    'general',
    'special',
    'annual'
  ]

  belongs_to :proposed_law, inverse_of: :adopted_law

  validates :adopted_on, presence: true
  validates :proposed_law, presence: true
  validates :executive_action_on, presence: true,
    if: :executive_jurisdiction?
  validates :executive_action, presence: true,
    inclusion: { in: EXECUTIVE_ACTIONS },
    if: :executive_jurisdiction?
  validates :referendum_type, presence: true, if: :referendum_required?,
    inclusion: { in: REFERENDUM_TYPES }
  validates :election_type, presence: true, if: :election_required?,
    inclusion: { in: ELECTION_TYPES }
  validates :permissive_petition, inclusion: { in: [ true, false ] },
    if: :permissive_referendum?
  validates :referendum_required, inclusion: { in: [ true, false ] }
  validate :adopted_on_must_be_past_or_present,
    :executive_action_on_must_be_before_or_at_adopted_on

  def adopted_on_must_be_past_or_present
    return unless adopted_on?
    if adopted_on > Time.zone.today
      errors.add :adopted_on, 'may not be in the future'
    end
  end

  def executive_action_on_must_be_before_or_at_adopted_on
    return unless adopted_on? && executive_action_on?
    if adopted_on < executive_action_on
      errors.add :executive_action_on, 'may not be after date of final adoption'
    end
  end

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
