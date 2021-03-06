require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "テストユーザー", email: "user@example.com", 
              password: "foobar", password_confirmation: "foobar")
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
  
  test "emailを小文字で登録する" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "passwordの存在性" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "passwordの最小文字数" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "ユーザのdigestがnilならauthenticated? はfalseを返す" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "紐づくmicropostもdestroyされる" do
    @user.save
    @user.microposts.create!(content: "さんぷる")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "following関連" do
    taro = users(:taro)
    jiro  = users(:jiro)
    assert_not taro.following?(jiro)
    taro.follow(jiro)
    assert taro.following?(jiro)
    assert jiro.followers.include?(taro)
    taro.unfollow(jiro)
    assert_not taro.following?(jiro)
  end

  test "feedに正しいpostが表示されている" do
    michael = users(:taro)
    archer  = users(:jiro)
    lana    = users(:lana)
    # フォローしているユーザーの投稿
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分の投稿
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

end