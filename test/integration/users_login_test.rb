require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:taro)
  end

  test "無効な情報でのログイン" do
    get login_path
    assert_template 'sessions/new' # テンプレートが描写されているか
    post login_path, params:{ session:{ email:"", password:"" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "有効な情報でのログイン" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert_redirected_to @user # リダイレクト先が正しいかチェック
    follow_redirect!  # そこに移動
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end