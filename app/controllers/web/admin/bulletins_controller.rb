class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  after_action :verify_authorized

  def moderate
    @bulletins = Bulletin.under_moderation.by_recently_created
    authorize [:admin, @bulletins]
  end

  def index
    @bulletins = Bulletin.all
    authorize([:admin, @bulletins])
  end
end
