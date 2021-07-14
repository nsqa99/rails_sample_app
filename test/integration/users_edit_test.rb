require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:nsqa)
  end

  test "unsuccessful update" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: "",
        email: "",
        password: "",
        password_confirmation: "",
      }
    }
    assert_template 'users/edit'
  end
  

  test "successful update" do
    log_in_as(@user)
    new_name = "QA"
    new_email = "nsqatest@gmail.com"
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: new_name,
        email: new_email,
        password: "",
        password_confirmation: "",
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end

  test "should do a friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    
    assert_redirected_to edit_user_url(@user)
  end

end
