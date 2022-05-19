# frozen_string_literal: true

module Web::Admin
  class HomeController < ApplicationController
    def index
      @bulletins = Bulletin.under_moderation
                           .by_recently_created
                           .page(params[:page])
                           .per(10)
    end
  end
end
