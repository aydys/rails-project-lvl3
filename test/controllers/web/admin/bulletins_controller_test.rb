require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = users :admin
  end

  test 'should get index' do
    sign_in @admin_user
    get admin_bulletins_url
    assert_response :success
  end
end
