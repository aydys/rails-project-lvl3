class Web::Admin::UsersController < Web::Admin::ApplicationController
  after_action :verify_authorized

  def index
    @users = User.all
    authorize [:admin, @users]
  end

  def destroy
    user = User.find params[:id]
    authorize [:admin, user]

    if user.destroy
      redirect_to admin_users_path, notice: 'User successfully deleted'
    else
      flash.now[:error] = 'Произошла ошибка'
      render :index
    end
  end
end
