class Admin::CategoryPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end
end