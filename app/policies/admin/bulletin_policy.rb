class Admin::BulletinPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end
end
