# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users :admin
    @regular_user = users :one
    @category = categories :category1
    @attrs = {
      name: Faker::Food.dish
    }
  end

  test 'should get index' do
    sign_in @admin
    get admin_categories_url
    assert_response :success
  end

  test 'regular user has no access to index' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      get admin_categories_url
    end
  end

  test 'should get new' do
    sign_in @admin
    get new_admin_category_url
    assert_response :success
  end

  test 'regular user has no access to new' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      get new_admin_category_url
    end
  end

  test 'should create new category' do
    sign_in @admin
    post admin_categories_url(params: { category: @attrs })
    category = Category.find_by(name: @attrs[:name])
    assert category
    assert_redirected_to admin_categories_url
  end

  test 'regular user has no access to create' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      post admin_categories_url(params: { category: @attrs })
    end
  end

  test 'should get edit' do
    sign_in @admin
    get edit_admin_category_url @category
    assert_response :success
  end

  test 'regular user has no access to edit' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      get edit_admin_category_url @category
    end
  end

  test 'should update category' do
    sign_in @admin
    patch admin_category_url(@category), params: { category: @attrs }
    category = Category.find_by(name: @attrs[:name])
    assert category
    assert_redirected_to admin_categories_path
  end

  test 'regular user has no access to update' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      patch admin_category_url(@category), params: { category: @attrs }
    end
  end

  test 'admin can destroy category' do
    sign_in @admin
    delete admin_category_url(@category)
    assert_response :redirect
    assert { !Category.exists?(@category.id) }
    assert_redirected_to admin_categories_path
  end

  test 'regular user has no access to delete category' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      delete admin_category_url(@category)
    end
  end
end
