class GitlabClientIdentityPolicy < GitlabClientIdentityRequestPolicy
  def destroy?
    be? || staff?
  end

  def index?
    be? || staff?
  end
end
