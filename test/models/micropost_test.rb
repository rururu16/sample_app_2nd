require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:taro)
    @micropost = @user.microposts.build(content: "さんぷるぽすと")
  end

  test "有効なデータ" do
    assert @micropost.valid?
  end

  test "user_idの存在性" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "contentの存在性" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "contentは140文字以内" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "マイクロソフトの並び順" do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
end
