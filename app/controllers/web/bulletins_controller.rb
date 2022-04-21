class Web::BulletinsController < Web::ApplicationController
  def index
    @bulletins = Bulletin.by_recently_created
  end

  def new
    @bulletin = Bulletin.new
  end

  def create
    @bulletin = Bulletin.new bulletin_params.merge(author_id: current_user&.id)
    if @bulletin.save!
      redirect_to root_path, notice: 'Bulletin was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @bulletin = Bulletin.find params[:id]
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
