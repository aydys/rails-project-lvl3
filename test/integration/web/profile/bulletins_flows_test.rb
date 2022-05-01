# frozen_string_literal: true

require 'test_helper'

class BulletinFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
  end

  test 'should get user bulletins' do
    sign_in @user
    get profile_url
    assert_response :success
    assert_select 'h2', 'Мои объявления'
    assert_select '[value=?]', 'Искать'
  end
end
