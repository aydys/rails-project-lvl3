# frozen_string_literal: true

require 'test_helper'

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
  end

  test 'should get user bulletins' do
    sign_in @user
    get profile_url
    assert_response :success
  end
end
