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
  #check image upload button
  assert_select 'input[type=file]'
  # invalid submission
  assert_no_difference "Micropost.count" do
    post microposts_path, params: {micropost: {content: ""}}
  end
  assert_select "div#error_explanation"
  #valid submission
  content = "what a wonderful day"
  picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
  assert_difference "Micropost.count", 1 do
    post microposts_path, params: { micropost: { content: content, picture: picture } }
  end
  assert assigns(:micropost).picture?
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

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{ @user.microposts.count } microposts", response.body
    # user with 0 microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A new micropost")
    get root_path
    assert_match '1 micropost', response.body
  end
end
