class UserPolicy < ApplicationPolicy
  def be?
    user.id == record.id
  end

  def index?
    user.staff? || user.admin?
  end

  def show?
    user.staff? || user.admin?
  end
end
