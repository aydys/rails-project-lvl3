# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = t('fail_authorization')
    redirect_back(fallback_location: root_path)
  end
end
