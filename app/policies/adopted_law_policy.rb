class AdoptedLawPolicy < ApplicationPolicy
  def create?
    Pundit.policy( user, record.proposed_law ).adopt?
  end

  def index?
    true
  end

  def show?
    true
  end
end
