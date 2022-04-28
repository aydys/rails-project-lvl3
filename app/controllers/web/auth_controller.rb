# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    email = auth[:info][:email].downcase
    existing_user = User.find_by(email: email)

    existing_user ||= User.create(name: auth[:info][:name], email: email)
    sign_in existing_user
    redirect_to root_path, notice: t('success')
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
