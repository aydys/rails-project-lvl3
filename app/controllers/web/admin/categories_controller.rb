# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  def index
    @categories = Category.all.page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash.now[:alert] = @category.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]

    if @category.update category_params
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash.now[:alert] = @category.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find params[:id]

    if category.destroy
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash.now[:error] = t('.error')
      render :index
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
