# frozen_string_literal: true

module Web
  class ProfilesController < ApplicationController
    def show
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
end
