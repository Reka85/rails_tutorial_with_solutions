

require 'test_helper'
class SessionsHelperTest < ActionView::TestCase
  #define user using fixtures
  def setup
    @user = users(:michael)
    #call the remember method to the user
    remember(@user)
  end

  test "current user returns right user when session is nil" do
    #verify that current_user is equal to the given user
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current user returns nil when remember digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

end
