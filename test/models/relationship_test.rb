require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:taro).id,
                                    followed_id: users(:jiro).id)
  end

  test "有効" do
    assert @relationship.valid?
  end

  test "follower_idの存在性" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "followed_idの存在性" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end