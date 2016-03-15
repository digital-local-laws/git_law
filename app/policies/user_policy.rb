class UserPolicy < ApplicationPolicy
  def be?
    user.id == record.id
  end

  def index?
    user.admin
  end

  def destroy?
    user.admin
  end

  def update?
    user.admin
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
