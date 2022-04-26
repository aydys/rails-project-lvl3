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

  def to_moderate?
    user
  end

  def archive?
    user
  end
end
