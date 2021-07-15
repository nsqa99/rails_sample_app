require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:nsqa2)
    @micropost = microposts(:orange)
    @owner = @micropost.user
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should not destroy when not owner" do
    log_in_as @user
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
  end
end
