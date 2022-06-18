# frozen_string_literal: true

# module Web
class Web::ProfilesController < Web::ApplicationController
  before_action :authenticate_user

  def show
    @states_collection = Bulletin.aasm.states.map do |state|
      [state.display_name, state.name]
    end

    @query = current_user.bulletins
                         .by_recently_created
                         .ransack(params[:q])
    @bulletins = @query
                 .result
                 .page(params[:page])
  end
end
# end
