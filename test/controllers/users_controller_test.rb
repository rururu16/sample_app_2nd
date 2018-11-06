require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:taro)
    @other_user = users(:jiro)
  end

  test "newページの表示" do
    get signup_path
    assert_response :success
  end

  test "他のユーザのeditへ" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "他のユーザのupdateへ" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  test "admin属性を変更" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              @other_user.password,
                                            password_confirmation: @other_user.password_confirmation,
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "ログインせずindexへリダイレクト" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "ログインせずdestroyへリダイレクト" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "admin以外のユーザでdestroyへリダイレクト" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "ログインせずfollowingにリダイレクト" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "ログインせずにfollowersへリダイレクト" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
