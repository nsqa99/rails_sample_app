require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          name: "Test",
          email: "user@gmail.com",
          password: "foo123",
          password_confirmation: "foo123"
        }
      }
    end

    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert logged_in?
  end


end
