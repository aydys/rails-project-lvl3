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
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      get admin_bulletins_url
    end
  end

  test 'should get admin page' do
    sign_in @admin_user
    get admin_root_url
    assert_response :success
  end

  test 'regular user cannt get admin root page' do
    assert_raises(Pundit::NotAuthorizedError) do
      sign_in @regular_user
      get admin_root_url
    end
  end

  test 'should change state from under_moderation to published' do
    test_state_admin(:under_moderation, 'publish', 'published')
  end

  test 'should change state from under_moderation to reject' do
    test_state_admin(:under_moderation, 'reject', 'rejected')
  end

  private

  def test_state_admin(prev_state_bulletin, event, next_state)
    bulletin = bulletins prev_state_bulletin
    sign_in users :admin
    patch_with_referer send("#{event}_admin_bulletin_url", bulletin),
                       { bulletin: @attrs, redirect_path: admin_root_url }
    bulletin.reload
    assert { bulletin.send("#{next_state}?") }
  end
end
