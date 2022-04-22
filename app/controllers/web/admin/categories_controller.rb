class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  after_action :verify_authorized
  def index
    @categories = Category.all
    authorize [:admin, @categories]
  end

  def new
  end

  def create
  end

  def edit
  end

  def show
  end

  def destroy
  end
end
