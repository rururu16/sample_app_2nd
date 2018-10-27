require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "無効な情報を登録" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar" } }
    end
    assert_template 'users/new' # 再描画されているか
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'form[action="/signup"]'
  end 
  
  test "有効な情報を登録" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                        email: "user@example.com",
                                        password:              "password",
                                        password_confirmation: "password" } }
    end
    follow_redirect! # 指定したリダイレクト先へ移動
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
