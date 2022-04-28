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

  def archive
    bulletin = Bulletin.find params[:id]
    authorize bulletin
    if bulletin.archive!
      redirect_to request.referer, notice: t('web.bulletins.flash_states.archived')
    else
      redirect_to request.referer, alert: t('web.bulletins.flash_states.failed')
    end
  end
end
