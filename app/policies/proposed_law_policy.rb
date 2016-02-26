class ProposedLawPolicy < ApplicationPolicy
  def adopt?
    Pundit.policy( user, record.jurisdiction ).adopt?
  end

  def propose?
    Pundit.policy( user, record.jurisdiction ).propose?
  end

  def own?
    propose? && record.user == user
  end

  def create?
    propose?
  end

  def update?
    own?
  end

  def destroy?
    own?
  end

  def index?
    true
  end

  def show?
    true
  end
end
