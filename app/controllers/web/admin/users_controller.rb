class Web::Admin::UsersController < Web::Admin::ApplicationController
  after_action :verify_authorized

  def index
    @users = User.all.page(params[:page]).per(10)
    authorize [:admin, @users]
  end

  def destroy
    user = User.find params[:id]
    authorize [:admin, user]

    if user.destroy
      redirect_to admin_users_path, notice: t('.success')
    else
      flash.now[:error] = t('.error')
      render :index
    end
  end
end
