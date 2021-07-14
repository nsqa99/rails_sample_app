require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:nsqa)
    @other_user = users(:nsqa2)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect to login page when get to edit page" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect to login page when send request" do
    patch user_path(@user), params: { 
      user: { 
        name: @user.name,
        email: @user.email 
      } 
    }
    
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect to root page when get to edit page of other" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert_redirected_to root_url
  end

  test "should redirect to root page when try to edit other user" do
    log_in_as(@user)
    patch user_path(@other_user), params: { 
      user: { 
        name: @user.name,
        email: @user.email
      } 
    }
    assert_redirected_to root_url
  end

  test "shoud redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "admin should not be editable" do
    log_in_as(@other_user)
    patch user_path(@other_user), params: {
      user: {
        name: "no",
        email: "wayroundhere@example.com",
        admin: "1"
      }
    }
    @other_user.reload
    assert_not @other_user.admin?
  end
end
