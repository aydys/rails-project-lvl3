# frozen_string_literal: true

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
    sign_in @regular_user
    get admin_bulletins_url
    assert_redirected_to root_url
  end

  test 'should get admin page' do
    sign_in @admin_user
    get admin_root_url
    assert_response :success
  end

  test 'regular user cannot get admin root page' do
    sign_in @regular_user
    get admin_root_url
    assert_redirected_to root_url
  end

  test 'should change state from under_moderation to published' do
    bulletin = bulletins :under_moderation
    sign_in users :admin
    patch publish_admin_bulletin_url(bulletin)
    bulletin.reload
    assert { bulletin.published? }
  end

  test 'should change state from under_moderation to reject' do
    bulletin = bulletins :under_moderation
    sign_in users :admin
    patch reject_admin_bulletin_url(bulletin)
    bulletin.reload
    assert { bulletin.rejected? }
  end
end
