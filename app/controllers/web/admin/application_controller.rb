# frozen_string_literal: true

class Web::Admin::ApplicationController < Web::ApplicationController
  before_action :authorize_admin

  def authorize_admin
    authorize :admin, :user_is_admin?
  end
end
