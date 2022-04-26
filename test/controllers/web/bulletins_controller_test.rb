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
      author_id: @user
    }
  end

  test 'should get index' do
    sign_in @user
    get bulletins_url
    assert_response :success
  end

  test 'guest should raise error from new' do
    assert_raises(Pundit::NotAuthorizedError) do
      get new_bulletin_url
    end
  end

  test 'should get new' do
    sign_in @user
    get new_bulletin_url
    assert_response :success
  end

  test 'guest cant create bulletin' do
    assert_raises(Pundit::NotAuthorizedError) do
      post bulletins_url, params: { bulletin: @attrs }
    end
  end

  test 'should create bulletin' do
    sign_in @user
    post bulletins_url, params: { bulletin: @attrs }
    bulletin = Bulletin.find_by title: @attrs[:title]
    assert { bulletin.description == @attrs[:description] }
    assert_redirected_to profile_root_url
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

  test 'guest should raise error from edit' do
    assert_raises(Pundit::NotAuthorizedError) do
      get edit_bulletin_url @bulletin
    end
  end

  test 'should update bulletin' do
    sign_in @user
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }
    bulletin = Bulletin.find @bulletin.id
    assert { bulletin.title == @attrs[:title] }
    assert_redirected_to profile_root_url
  end

  test 'guest cannot update bulletin' do
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulletin_url(@bulletin), params: { bulletin: @attrs }      
    end
  end

  test 'should change state to under_moderation' do
    bulletin = bulletins :on_draft
    sign_in @user
    patch bulletin_moderate_url(bulletin), params: { bulletin: @attrs }
    assert_response :redirect
    bulletin.reload
    assert { bulletin.under_moderation? }
  end
  test 'guest cannot change state to under_moderation' do
    assert_raises(Pundit::NotAuthorizedError) do
      bulletin = bulletins :on_draft
      patch bulletin_moderate_url(bulletin), params: { bulletin: @attrs }
    end
  end
end
