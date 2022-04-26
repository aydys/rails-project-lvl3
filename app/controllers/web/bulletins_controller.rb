class Web::BulletinsController < Web::ApplicationController
  after_action :verify_authorized, except: %i[index show]

  def index
    @bulletins = Bulletin.published.by_recently_created
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
    set_state(:moderate, 'moderated', 'profile')
  end

  def archive
    set_state(:archive, 'archived', 'profile')
  end

  def publish
    set_state(:publish, 'published', 'admin')
  end

  def reject
    set_state(:reject, 'rejected', 'admin')
  end

  private

  def set_state(event, reached_state, root_path)
    events = Bulletin.aasm.events.map(&:name)
    bulletin = Bulletin.find params[:id]
    authorize bulletin
    if events.include?(event)
      if bulletin.send("#{event}!")
        redirect_to send("#{root_path}_root_path"), notice: "Bulletin successfully #{reached_state}"
      else
        redirect_to send("#{root_path}_root_path"), alert: 'Failed'
      end
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
