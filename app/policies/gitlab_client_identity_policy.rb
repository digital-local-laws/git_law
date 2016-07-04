class GitlabClientIdentityPolicy < ApplicationPolicy
  def be?
    Pundit.policy( user, record.user ).be?
  end

  def new?
    be?
  end

  def create?
    be?
  end

  def destroy?
    be? || user.staff? || user.admin?
  end

  def index?
    be? || user.staff? || user.admin?
  end

  def show?
    be? || user.staff? || user.admin?
  end
end
