class Web::BulletinsController < Web::ApplicationController
  after_action :verify_authorized, except: %i[index show]

  def index
    @bulletins = Bulletin.by_recently_created
  end

  def new
    @bulletin = Bulletin.new
    authorize @bulletin
  end

  def create
    @bulletin = Bulletin.new bulletin_params.merge(author_id: current_user&.id)
    authorize @bulletin
    if @bulletin.save!
      redirect_to profile_root_path, notice: 'Bulletin was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @bulletin = Bulletin.find params[:id]
  end

  def edit
    @bulletin = Bulletin.find params[:id]
    authorize @bulletin
  end

  def update
    bulletin = Bulletin.find params[:id]
    authorize bulletin
    if bulletin.update bulletin_params
      redirect_to profile_root_path, notice: 'Bulletin successfully updated'
    else
      redirect_to profile_root_path, alert: 'Failed'
    end
  end

  def to_moderate
    bulletin = Bulletin.find params[:id]
    authorize bulletin
    if bulletin.moderate!
      redirect_to profile_root_path, notice: 'Bulletin send to moderation'
    else
      redirect_to profile_root_path, alert: 'Failed'
    end
  end

  def archive
    bulletin = Bulletin.find params[:id]
    authorize bulletin
    if bulletin.archive!
      redirect_to profile_root_path, notice: 'Bulletin successfully archived'
    else
      redirect_to profile_root_path, alert: 'Failed'
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(
      :title,
      :description,
      :category_id,
      :image
    )
  end
end
