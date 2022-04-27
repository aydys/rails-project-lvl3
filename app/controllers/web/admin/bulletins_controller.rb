class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  after_action :verify_authorized

  def moderate
    @bulletins = Bulletin.under_moderation
                         .by_recently_created
                         .page(params[:page]).per(10)
    authorize [:admin, @bulletins]
  end

  def index
    @query = Bulletin.by_recently_created
                     .page(params[:page])
                     .ransack(params[:q])
    @bulletins = @query.result
    authorize([:admin, @bulletins])
  end
end
