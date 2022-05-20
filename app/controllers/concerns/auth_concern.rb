# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  included do
    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      reset_session
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def signed_in?
      current_user.present?
    end

    def authenticate_user
      return if signed_in?

      flash[:alert] = t('fail_authentication')
      redirect_back(fallback_location: root_url)
    end
  end
end
