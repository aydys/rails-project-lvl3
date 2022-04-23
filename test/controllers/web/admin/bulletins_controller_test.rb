require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = users :admin
    @regular_user = users :one
  end

  test 'should get index' do
    sign_in @admin_user
    get admin_bulletins_url
    assert_response :success
  end

  test 'regular user cannt get index' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      get admin_bulletins_url
    end
  end
end
