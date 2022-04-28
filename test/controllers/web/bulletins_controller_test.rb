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
    assert_redirected_to profile_url
  end

  test 'guest cannot update bulletin' do
    assert_raises(Pundit::NotAuthorizedError) do
      patch bulletin_url(@bulletin), params: { bulletin: @attrs }
    end
  end

  test 'should change state to under_moderation' do
    test_state(:on_draft, 'moderate', 'under_moderation')
  end

  test 'guest cannot change state to under_moderation' do
    assert_raises(Pundit::NotAuthorizedError) do
      bulletin = bulletins :on_draft
      patch moderate_bulletin_url(bulletin), params: { bulletin: @attrs }
    end
  end

  test 'should change state to archive from draft' do
    test_state(:on_draft, 'archive', 'archived')
  end

  test 'guest cannot change state to archived' do
    assert_raises(Pundit::NotAuthorizedError) do
      bulletin = bulletins :on_draft
      patch archive_bulletin_url(bulletin), params: { bulletin: @attrs }
    end
  end

  test 'should change state to archive from under_moderation' do
    test_state(:under_moderation, 'archive', 'archived')
  end

  test 'should change state to archive from rejected' do
    test_state(:rejected, 'archive', 'archived')
  end

  test 'should change state to archive from published' do
    test_state(:published, 'archive', 'archived')
  end

  test 'should change state from under_moderation to published' do
    test_state_admin(:under_moderation, 'publish', 'published')
  end

  test 'should change state from under_moderation to reject' do
    test_state_admin(:under_moderation, 'reject', 'rejected')
  end

  private

  def test_state(prev_state_bulletin, event, next_state)
    bulletin = bulletins prev_state_bulletin
    sign_in users :admin
    patch_with_referer send("#{event}_bulletin_url", bulletin),
                       { bulletin: @attrs, redirect_path: profile_url }
    bulletin.reload
    assert { bulletin.send("#{next_state}?") }
  end

  def test_state_admin(prev_state_bulletin, event, next_state)
    bulletin = bulletins prev_state_bulletin
    sign_in users :admin
    patch_with_referer send("#{event}_admin_bulletin_url", bulletin),
                       { bulletin: @attrs, redirect_path: admin_root_url }
    bulletin.reload
    assert { bulletin.send("#{next_state}?") }
  end
end
