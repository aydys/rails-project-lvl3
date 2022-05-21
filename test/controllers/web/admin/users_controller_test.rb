# frozen_string_literal: true

require 'test_helper'

class Web::Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users :admin
    @regular_user = users :one
    @user = users :two
  end

  test 'should get index' do
    sign_in @admin
    get admin_users_url
    assert_response :success
  end

  test 'regular user has no access to index' do
    sign_in @regular_user
    get admin_users_url
    assert_redirected_to(root_url)
  end

  test 'should destroy user by admin' do
    sign_in @admin
    delete admin_user_url(@user)
    assert_response :redirect
    assert { !User.exists?(email: @user[:email]) }
    assert_redirected_to admin_users_url
  end

  test 'regular user cannot destroy user' do
    sign_in @regular_user
    delete admin_user_url(@user)
    assert { User.exists? id: @user.id }
    assert_redirected_to(root_url)
  end
end
