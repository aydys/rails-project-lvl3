class Web::SessionsController < ApplicationController
  def destroy
    sign_out
    redirect_to root_path, notice: t('success')
  end
end
