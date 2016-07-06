class GitlabClientIdentityRequestPolicy < ApplicationPolicy
  def be?
    Pundit.policy( user, record.user ).be?
  end

  def create?
    be? || staff?
  end

  def show?
    be? || staff?
  end
end
