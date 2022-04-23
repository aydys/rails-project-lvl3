class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  after_action :verify_authorized
  def index
    @categories = Category.all
    authorize [:admin, @categories]
  end

  def new
    @category = Category.new
    authorize [:admin, @category]
  end

  def create
    @category = Category.new(category_params)
    authorize [:admin, @category]
    if @category.save
      redirect_to admin_categories_path, notice: 'Category successfully created'
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def destroy
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
