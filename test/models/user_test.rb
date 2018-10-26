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
  
  test "nameの文字数超過" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "emailの文字数超過" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "emailのフォーマット：有効" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} は有効"
    end
  end
  test "emailのフォーマット：無効" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} は無効"
    end
  end

  test "emailの一意性" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
end
