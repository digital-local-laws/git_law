class JurisdictionPolicy < ApplicationPolicy
  def adopt?
    record.users.where( '"jurisdiction_memberships"."adopt" = ?', true ).
    where( id: user.id ).any?
  end

  def index?
    true
  end

  def show?
    true
  end
end
