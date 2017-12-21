require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "invalid login information" do
    get login_path #1. visit login page
    assert_template 'sessions/new' #2. verify that new session form appears properly
    post "/login", params: { session: { email:"invalid.com", password: "a" *5 } } #3. post to the sessions path with invalid params hash
    assert_template 'sessions/new'
    assert_equal 'Invalid email/password combination', flash[:danger]#4. verify that new sesion form gets re-rendered & flash appears
    get root_path #5. visit another page
    assert_not_equal 'Invalid email/password combination', flash[:danger]#6.verify that flash doesn't appear on that page
  end
end
