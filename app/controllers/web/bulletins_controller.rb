# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :authenticate_user,
                only: %i[new create edit update moderate archive]
  after_action :verify_authorized,
               only: %i[show edit update moderate archive]

  def index
    @query = Bulletin.published
                     .by_recently_created
                     .page(params[:page])
                     .ransack(params[:q])
    @bulletins = @query.result.includes(:category)
  end

  def new
    @bulletin = Bulletin.new
  end

  def create
    @bulletin = Bulletin.new bulletin_params.merge(user_id: current_user&.id)
    if @bulletin.save
      redirect_to profile_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @bulletin = find_bulletin
    authorize @bulletin
  end

  def edit
    @bulletin = find_bulletin
    authorize @bulletin
  end

  def update
    @bulletin = find_bulletin
    authorize @bulletin
    if @bulletin.update bulletin_params
      redirect_to profile_path, notice: t('.update')
    else
      flash.now[:alert] = t('.error')
      render :edit, status: :unprocessable_entity
    end
  end

  def moderate
    change_state(:moderate)
  end

  def archive
    change_state(:archive)
  end

  private

  def find_bulletin
    Bulletin.find params[:id]
  end

  def change_state(event)
    @bulletin = find_bulletin
    return unless @bulletin.send("may_#{event}?")

    authorize @bulletin
    if @bulletin.send("#{event}!")
      redirect_to profile_path, notice: t("web.bulletins.flash_states.#{@bulletin.state}")
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
