# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @bulletin = bulletins :bulletin1
    @attrs = {
      title: Faker::Food.dish,
      description: Faker::Food.description,
      category_id: categories(:category1).id,
      image: fixture_file_upload('hexlet.jpg', 'image/jpg'),
      user: @user
    }
  end

  test 'should get index' do
    sign_in @user
    get bulletins_url
    assert_response :success
  end

  test 'guest guest does not have access to new' do
    get new_bulletin_url
    assert_redirected_to root_url
  end

  test 'should get new' do
    sign_in @user
    get new_bulletin_url
    assert_response :success
  end

  test 'guest cant create bulletin' do
    post bulletins_url, params: { bulletin: @attrs }
    assert_redirected_to root_url
  end

  test 'should create bulletin' do
    sign_in @user
    post bulletins_url, params: { bulletin: @attrs }
    assert { Bulletin.exists? @attrs.except(:image) }
    assert_redirected_to profile_url
  end

  test 'should get show' do
    sign_in @user
    get bulletin_url @bulletin
    assert_response :success
  end

  test 'should get edit' do
    sign_in @user
    get edit_bulletin_url @bulletin
    assert_response :success
  end

  test 'guest guest does not have access to edit' do
    get edit_bulletin_url @bulletin
    assert_redirected_to root_url
  end

  test 'should update bulletin' do
    sign_in @user
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }
    assert { Bulletin.exists? @attrs.except(:image) }
    assert_redirected_to profile_url
  end

  test 'guest cannot update bulletin' do
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }
    assert_redirected_to root_url
  end

  test 'should change state to archive from draft' do
    bulletin = bulletins :on_draft
    sign_in @user
    patch archive_bulletin_url(bulletin)
    bulletin.reload
    assert { bulletin.archived? }
  end

  test 'should change state to archive from under_moderation' do
    bulletin = bulletins :under_moderation
    sign_in @user
    patch archive_bulletin_url(bulletin)
    bulletin.reload
    assert { bulletin.archived? }
  end

  test 'should change state to archive from rejected' do
    bulletin = bulletins :rejected
    sign_in @user
    patch archive_bulletin_url(bulletin)
    bulletin.reload
    assert { bulletin.archived? }
  end

  test 'should change state to archive from published' do
    bulletin = bulletins :published
    sign_in @user
    patch archive_bulletin_url(bulletin)
    bulletin.reload
    assert { bulletin.archived? }
  end
end
