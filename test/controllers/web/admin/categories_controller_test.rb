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
    sign_in @regular_user
    get admin_categories_url
    assert_redirected_to root_url
  end

  test 'should get new' do
    sign_in @admin
    get new_admin_category_url
    assert_response :success
  end

  test 'regular user has no access to new' do
    sign_in @regular_user
    get new_admin_category_url
    assert_redirected_to root_url
  end

  test 'should create new category' do
    sign_in @admin
    post admin_categories_url(params: { category: @attrs })
    assert { Category.exists? @attrs }
    assert_redirected_to admin_categories_url
  end

  test 'regular user has no access to create' do
    sign_in @regular_user
    before_count = Category.all.size
    post admin_categories_url(params: { category: @attrs })
    after_count = Category.all.size
    assert { before_count == after_count }
    assert_redirected_to root_url
  end

  test 'should get edit' do
    sign_in @admin
    get edit_admin_category_url @category
    assert_response :success
  end

  test 'regular user has no access to edit' do
    sign_in @regular_user
    get edit_admin_category_url @category
    assert_redirected_to root_url
  end

  test 'should update category' do
    sign_in @admin
    patch admin_category_url(@category), params: { category: @attrs }
    assert { Category.exists? @attrs }
    assert_redirected_to admin_categories_path
  end

  test 'regular user has no access to update' do
    sign_in @regular_user
    before_category = Category.find_by(@attrs)
    patch admin_category_url(@category), params: { category: @attrs }
    after_category = Category.find_by(@attrs)
    assert { before_category == after_category }
    assert_redirected_to root_url
  end

  test 'admin can destroy category' do
    sign_in @admin
    delete admin_category_url(@category)
    assert_response :redirect
    assert { !Category.exists?(@category.id) }
    assert_redirected_to admin_categories_path
  end

  test 'regular user has no access to delete category' do
    sign_in @regular_user
    delete admin_category_url(@category)
    assert { Category.exists? id: @category.id }
    assert_redirected_to root_url
  end
end
