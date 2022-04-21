class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit
end
