require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template "users/show"
    #check for page title
    assert_select "title", full_title(@user.name)
    #users name
    assert_select 'h1', text: @user.name
    #gravatar
    assert_select 'h1>img.gravatar'
    #micropost count
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    #paginated microposts
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
