# frozen_string_literal: true

class Web::SessionsController < Web::ApplicationController
  before_action :authenticate_user

  def destroy
    sign_out
    redirect_to root_path, notice: t('success')
  end
end
