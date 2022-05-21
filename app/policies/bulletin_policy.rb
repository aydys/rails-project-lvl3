# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def edit?
    user.id == record.user_id
  end

  def show?
    record.published? || user.admin? || edit?
  end

  def update?
    edit?
  end

  def moderate?
    edit?
  end

  def archive?
    edit?
  end
end
