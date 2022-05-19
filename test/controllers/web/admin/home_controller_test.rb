# frozen_string_literal: true

require 'test_helper'

class Web::Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in users(:admin)
    get admin_root_url
    assert_response :success
  end
end
