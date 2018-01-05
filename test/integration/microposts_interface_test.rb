require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
  #login
  log_in_as(@user)
  get root_path
  #check micropost pagination
  assert_select "div.pagination"
  # invalid submission
  assert_no_difference "Micropost.count" do
    post microposts_path, params: {micropost: {content: ""}}
  end
  assert_select "div#error_explanation"
  #valid submission
  content = "what a wonderful day"
  assert_difference "Micropost.count", 1 do
    post microposts_path, params: { micropost: { content: content } }
  end
  assert_redirected_to root_url
  follow_redirect!
  assert_match content, response.body
  #delete a post
  assert_select "a", text: "delete"
  first_post = @user.microposts.paginate(page: 1).first
  assert_difference "Micropost.count", -1 do
    delete micropost_path(first_post)
  end
  #visit a second users page
  get user_path(users(:archer))
  #no 'delete' links there
  assert_select "a", text: "delete", count: 0
  end
end
