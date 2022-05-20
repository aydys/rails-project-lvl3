# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def user_not_authorized
    flash[:alert] = t('fail_authorization')
    redirect_back(fallback_location: root_path)
  end

  def record_not_found
    render file: Rails.root.join('public/404.html'), status: :not_found
  end
end
