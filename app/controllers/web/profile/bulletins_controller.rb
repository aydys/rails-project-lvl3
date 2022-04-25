class Web::Profile::BulletinsController < Web::Profile::ApplicationController
  def index
    @bulletins = current_user.bulletins.order(created_at: :desc)
  end
end
