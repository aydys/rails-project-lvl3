# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def edit?
    user.id == record.user_id
  end

  def show?
    return record.published? unless user

    if user.admin?
      true
    else
      user.id == record.user_id
    end
  end

  def update?
    user.id == record.user_id
  end

  def moderate?
    user.id == record.user_id
  end

  def archive?
    user.id == record.user_id
  end
end
