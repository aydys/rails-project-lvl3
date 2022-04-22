class Admin::CategoryPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def new?
    create?
  end

  def create?
    user&.admin?
  end
end
