require "test_helper"

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users :admin
    @regular_user = users :one
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
end
