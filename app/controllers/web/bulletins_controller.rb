# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  after_action :verify_authorized, except: %i[index show]
  before_action :find_bulletin, only: %i[show edit update]

  def index
    @query = Bulletin.published
                     .by_recently_created
                     .page(params[:page])
                     .ransack(params[:q])
    @bulletins = @query.result.includes(:category)
  end

  def new
    @bulletin = Bulletin.new
    authorize @bulletin
  end

  def create
    @bulletin = Bulletin.new bulletin_params.merge(user_id: current_user&.id)
    authorize @bulletin
    if @bulletin.save
      redirect_to profile_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    authorize @bulletin
  end

  def update
    authorize @bulletin
    if @bulletin.update bulletin_params
      redirect_to profile_path, notice: t('.update')
    else
      flash.now[:alert] = t('.error')
      render :edit, status: :unprocessable_entity
    end
  end

  def moderate
    set_state(:moderate, 'moderated')
  end

  def archive
    set_state(:archive, 'archived')
  end

  private

  def find_bulletin
    @bulletin = Bulletin.find params[:id]
  end

  def set_state(event, reached_state)
    find_bulletin
    return unless @bulletin.send("may_#{event}?")

    authorize @bulletin
    if @bulletin.send("#{event}!")
      redirect_to profile_path, notice: t("web.bulletins.flash_states.#{reached_state}")
    else
      redirect_to profile_path, alert: t('web.bulletins.flash_states.failed')
    end
  end

  def bulletin_params
    params.require(:bulletin).permit(
      :title,
      :description,
      :category_id,
      :image
    )
  end
end
