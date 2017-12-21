require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "invalid login information" do
    get login_path #1. visit login page
    assert_template 'sessions/new' #2. verify that new session form appears properly
    post "/login", params: { session: { email:"invalid.com", password: "a" *5 } } #3. post to the sessions path with invalid params hash
    assert_template 'sessions/new'
    assert_equal 'Invalid email/password combination', flash[:danger]#4. verify that new sesion form gets re-rendered & flash appears
    get root_path #5. visit another page
    assert_not_equal 'Invalid email/password combination', flash[:danger]#6.verify that flash doesn't appear on that page
  end

  test 'login with valid information' do
    get login_path #1. visit the login path
    post '/login', params: { session: { email: @user.email, password: "password" } }#2. post valid info to the sessions path
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count=0 #3. verify that login link disappears
    assert_select "a[href=?]", logout_path #4. verify that logout link appears
    assert_select "a[href=?]", user_path(@user)#5. verify that profile link appears
  end
end
