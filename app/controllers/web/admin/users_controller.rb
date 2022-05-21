# frozen_string_literal: true

class Web::Admin::UsersController < Web::Admin::ApplicationController
  def index
    @users = User.all.page(params[:page]).per(10)
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
