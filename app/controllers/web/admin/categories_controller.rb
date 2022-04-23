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
    @category = Category.find params[:id]
    authorize [:admin, @category]
  end

  def update
    @category = Category.find params[:id]
    authorize [:admin, @category]

    if @category.update category_params
      redirect_to admin_categories_path, notice: 'Category successfully updated'
    else
      render :edit
    end
  end

  def destroy
    category = Category.find params[:id]
    authorize [:admin, category]

    if category.destroy
      redirect_to admin_categories_path, notice: 'Category successfully deleted'
    else
      flash.now[:error] = 'Произошла ошибка'
      render :index
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
