# frozen_string_literal: true

class Admin::UserPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def destroy?
    user&.admin? && record.id != user.id
  end
end
