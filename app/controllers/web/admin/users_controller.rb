class Web::Admin::UsersController < Web::Admin::ApplicationController
  after_action :verify_authorized

  def index
    @users = User.all
    authorize [:admin, @users]
  end
end