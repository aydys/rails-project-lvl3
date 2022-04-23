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
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      get admin_users_url
    end
  end

  test 'should destroy user by admin' do
    sign_in @admin
    delete admin_user_url(@user)
    assert_response :redirect
    assert { !User.exists?(email: @user[:email]) }
    assert_redirected_to admin_users_url
  end

  test 'regular user cannot destroy user' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      delete admin_user_url(@user)
    end
  end
end
