require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @bulletin = bulletins :bulletin1
    @attrs = {
      title: Faker::Food.dish,
      description: Faker::Food.description,
      category_id: categories(:category1).id,
      image: fixture_file_upload('hexlet.jpg', 'image/jpg')
    }
  end

  test 'should get index' do
    sign_in @user
    get bulletins_url
    assert_response :success
  end

  test 'should get new' do
    sign_in @user
    get new_bulletin_url
    assert_response :success
  end

  test 'should create bulletin' do
    sign_in @user
    post bulletins_url, params: { bulletin: @attrs }
    bulletin = Bulletin.find_by title: @attrs[:title]
    assert { bulletin.description == @attrs[:description] }
    assert_redirected_to root_url
  end

  test 'should get show' do
    sign_in @user
    get bulletin_url @bulletin
    assert_response :success
  end
end
