# frozen_string_literal: true

class Admin::UserPolicy < ApplicationPolicy
  def destroy?
    record.id != user.id
  end
end
