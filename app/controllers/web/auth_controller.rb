# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    email = auth[:info][:email].downcase
    name = auth[:info][:name]
    existing_user = User.find_or_create_by(name: name, email: email)
    if existing_user
      sign_in existing_user
      redirect_to root_path, notice: t('success')
    else
      redirect_to root_path, alert: t('failed')
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
