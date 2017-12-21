require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "invalid login information" do
    get login_path # 1. visit login page
    assert_template 'sessions/new' # 2. verify that new session form appears properly
    post "/login", params: { session: { email:"invalid.com", password: "a" *5 } } # 3. post to the sessions path with invalid params hash
    assert_template 'sessions/new'
    assert_equal 'Invalid email/password combination', flash[:danger] # 4. verify that new sesion form gets re-rendered & flash appears
    get root_path # 5. visit another page
    assert_not_equal 'Invalid email/password combination', flash[:danger] # 6.verify that flash doesn't appear on that page
  end

  test 'login with valid information' do
    get login_path # 1. visit the login path
    post '/login', params: { session: { email: @user.email, password: "password" } } # 2. post valid info to the sessions path
    assert is_logged_in? # verify that user is logged in
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0 # 3. verify that login link disappears
    assert_select "a[href=?]", logout_path # 4. verify that logout link appears
    assert_select "a[href=?]", user_path(@user) # 5. verify that profile link appears
    # testing logout
    delete "/logout" # 1.issue delete request to logout path
    assert_not is_logged_in? # 2.verify user is logged out
    assert_redirected_to root_path # 3.verify that user is redirected to the root url
    follow_redirect!
    assert_template "/"
    assert_select "a[href=?]", login_path # 4.check that login link reappears
    assert_select "a[href=?]", logout_path, count: 0 # 5.check that logout link disappear
    assert_select "a[href=?]", user_path(@user), count: 0 # 6.check that profile link disappear
  end
end
