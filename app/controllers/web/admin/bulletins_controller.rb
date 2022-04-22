class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  after_action :verify_authorized, except: %i[moderate]

  def moderate; end

  def index
    @bulletins = Bulletin.all
    authorize([:admin, @bulletins])
  end
end
