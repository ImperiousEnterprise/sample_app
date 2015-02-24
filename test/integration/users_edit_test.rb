require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:adefemi)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end
  
  test "successful edit" do
      log_in_as(@user)
      get edit_user_path(@user)
      assert_template 'users/edit'
      name  = "Foo Bar"
      email = "foo@bar.com"
      patch user_path(@user), user: { name:  name,
                                      email: email,
                                      password:              "",
                                      password_confirmation: "" }
      assert_not flash.empty?
      assert_redirected_to @user
      @user.reload
      assert_equal @user.name,  name
      assert_equal @user.email, email
    end
    
  test "successful edit with friendly forwarding" do
      get edit_user_path(@user)
      log_in_as(@user)
      assert_redirected_to edit_user_path(@user)
      log_in_as(@user)
      assert_redirected_to @user
#      name  = "Foo Bar"
#      email = "foo@bar.com"
#      patch user_path(@user), user: { name:  name,
#                                      email: email,
#                                      password:              "foobar",
#                                      password_confirmation: "foobar" }
#      
#      assert_not flash.empty?
#      assert_redirected_to @user
#      @user.reload
#      assert_equal @user.name,  name
#      assert_equal @user.email, email
    
    end
    
   test "layout links" do
     get root_path
     # Not logged in so a "Login" link will be present
     assert_select "a[href=?]", login_path
     assert_select "a[href=?]", root_path
     assert_select "a[href=?]", help_path
     assert_select "a[href=?]", signup_path
     # Login
     log_in_as(@user)
     # Go to root
     get root_path
     # Now logged in so a "Login" link won't be present
     assert_select "a[href=?]", login_path, count: 0
     # Now logged in so a "Logout" link will be present
     assert_select "a[href=?]", logout_path
     # Now logged in so a "Users" link will be present
     assert_select "a[href=?]", users_path
     # Now logged in so a "Accounts" link will be present
     assert_select 'a[href=?]', '#', text: 'Account'
     
   end
end