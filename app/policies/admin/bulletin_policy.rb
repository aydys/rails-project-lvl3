# frozen_string_literal: true

class Admin::BulletinPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def moderate?
    user&.admin?
  end
end
