# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    @query = Bulletin.by_recently_created
                     .page(params[:page])
                     .ransack(params[:q])
    @bulletins = @query.result
  end

  def archive
    @bulletin = find_bulletin
    if @bulletin.archive!
      redirect_back(fallback: admin_root_path, notice: t('web.bulletins.flash_states.archived'))
    else
      redirect_back(fallback: admin_root_path, alert: t('web.bulletins.flash_states.failed'))
    end
  end

  def publish
    change_state(:publish)
  end

  def reject
    change_state(:reject)
  end

  private

  def change_state(event)
    @bulletin = find_bulletin
    return unless @bulletin.send("may_#{event}?")

    if @bulletin.send("#{event}!")
      redirect_to admin_root_path, notice: t("web.bulletins.flash_states.#{@bulletin.state}")
    else
      redirect_to admin_root_path, alert: t('web.bulletins.flash_states.failed')
    end
  end

  def find_bulletin
    Bulletin.find params[:id]
  end
end
