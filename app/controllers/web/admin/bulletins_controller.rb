class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def moderate; end

  def index
    @bulletins = Bulletin.all
  end
end
