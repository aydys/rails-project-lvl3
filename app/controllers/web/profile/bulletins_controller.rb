# frozen_string_literal: true

class Web::Profile::BulletinsController < Web::Profile::ApplicationController
  def index
    @states_collection = Bulletin.aasm.states.map do |state|
      [state.display_name, state.name]
    end

    @query = current_user.bulletins
                         .by_recently_created
                         .page(params[:page])
                         .ransack(params[:q])
    @bulletins = @query.result
  end
end
