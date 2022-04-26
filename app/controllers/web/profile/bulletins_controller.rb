class Web::Profile::BulletinsController < Web::Profile::ApplicationController
  def index
    @query = current_user.bulletins.by_recently_created.ransack(params[:q])
    @bulletins = @query.result
  end
end
