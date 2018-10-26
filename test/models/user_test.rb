require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "テストユーザー", email: "user@example.com")
  end

  test "ユーザーオブジェクトの有効性" do
    assert @user.valid?
  end

  test "nameの存在性" do
    @user.name=" " #空白文字列
    assert_not @user.valid?
  end

  test "emailの存在性" do
    @user.email=" " #空白文字列
    assert_not @user.valid?
  end
  

end
