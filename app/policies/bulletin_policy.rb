# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user
  end

  def edit?
    update?
  end

  def update?
    user
  end

  def moderate?
    user
  end

  def archive?
    user
  end

  def publish?
    user&.admin?
  end

  def reject?
    user&.admin?
  end
end
