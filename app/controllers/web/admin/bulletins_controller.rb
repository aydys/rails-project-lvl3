# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  after_action :verify_authorized
  before_action :find_bulletin, only: :archive

  def index
    @query = Bulletin.by_recently_created
                     .page(params[:page])
                     .ransack(params[:q])
    @bulletins = @query.result
  end

  def archive
    redirect_path = params[:moderation] ? admin_root_path : admin_bulletins_path
    if @bulletin.archive!
      redirect_to redirect_path, notice: t('web.bulletins.flash_states.archived')
    else
      redirect_to redirect_path, alert: t('web.bulletins.flash_states.failed')
    end
  end

  def publish
    set_state(:publish, 'published')
  end

  def reject
    set_state(:reject, 'rejected')
  end

  private

  def set_state(event, reached_state)
    find_bulletin
    return unless @bulletin.send("may_#{event}?")

    authorize @bulletin
    if @bulletin.send("#{event}!")
      redirect_to admin_root_path, notice: t("web.bulletins.flash_states.#{reached_state}")
    else
      redirect_to admin_root_path, alert: t('web.bulletins.flash_states.failed')
    end
  end

  def find_bulletin
    @bulletin = Bulletin.find params[:id]
  end
end
