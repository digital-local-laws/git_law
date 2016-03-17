class UserPolicy < ApplicationPolicy
  def be?
    user.id == record.id
  end

  def authorize?
    user.admin?
  end

  def index?
    user.staff? || user.admin?
  end

  def show?
    user.staff? || user.admin?
  end

  def permitted_attributes
    attributes = [ :first_name, :last_name, :email, :password,
      :password_confirmation ]
    if authorize?
      attributes += [ :admin, :staff ]
    end
    attributes
  end
end
