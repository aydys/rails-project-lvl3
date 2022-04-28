# frozen_string_literal: true

class Web::Profile::BulletinsController < Web::Profile::ApplicationController
  def index
    @query = current_user.bulletins
                         .by_recently_created
                         .page(params[:page])
                         .ransack(params[:q])
    @bulletins = @query.result
  end
end
