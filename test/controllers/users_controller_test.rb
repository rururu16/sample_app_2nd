require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "newページの表示" do
    get signup_path
    assert_response :success
  end

end
