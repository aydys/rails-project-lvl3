# frozen_string_literal: true

require 'test_helper'

class BulletinFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins :bulletin2
    @admin = users :admin
    @published_bulletin = bulletins :published
  end

  test 'should get main page' do
    get root_url
    assert_response :success
    assert_select 'h2', 'Объявления'
    assert_select '[value=?]', 'Искать'
  end

  test 'should get show page' do
    get bulletin_url(@published_bulletin)
    assert_response :success
    assert_select 'h2', @published_bulletin.title
  end

  test 'should get new form' do
    sign_in @admin
    get new_bulletin_url
    assert_response :success
    assert_select 'h2', 'Добавить объявление'
  end

  test 'should get edit form' do
    sign_in @admin
    get edit_bulletin_url @bulletin
    assert_response :success
    assert_select 'h2', 'Редактировать объявление'
  end
end
