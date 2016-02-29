class ProposedLawNodePolicy < ApplicationPolicy
  def propose?
    Pundit.policy( user, record.proposed_law ).update?
  end

  def create?
    propose?
  end

  def update?
    propose?
  end

  def destroy?
    propose?
  end

  def index?
    true
  end

  def show?
    true
  end
end
