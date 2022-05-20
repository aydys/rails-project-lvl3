# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def show?
    if user
      user.id == record.user_id
    else
      record.published?
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
