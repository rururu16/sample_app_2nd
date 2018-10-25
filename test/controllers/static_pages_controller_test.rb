require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "rootページ(home)を表示" do
    get root_path
    assert_response :success
    assert_select "title","#{@base_title}"
  end

  test "helpページを表示" do
    get help_path
    assert_response :success
    assert_select "title","Help | #{@base_title}"
  end

  test "aboutページを表示" do
    get about_path
    assert_response :success
    assert_select "title","About | #{@base_title}"
  end

  test "contactページを表示" do
    get contact_path
    assert_response :success
    assert_select "title","Contact | #{@base_title}"
  end

end
