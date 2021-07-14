require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:nsqa)
    @other_user = users(:nsqa2)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "should not delete when not being an admin" do
    log_in_as(@other_user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to root_url
    
  end
  
  test "should not delete when not logging in" do
    delete user_path(@user)
    assert_redirected_to login_url
  end

  test "should admin delete" do
    log_in_as(@user)
    assert_difference "User.count", -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_url
  end



end
