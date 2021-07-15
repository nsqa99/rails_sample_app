require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test user", email: "test@test.com", 
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "valid email addresses should be accepted" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org 
      user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Just testing")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    user_1 = users(:user_9)
    user_2 = users(:user_10)
    assert_not user_1.following?(user_2)
    user_1.follow(user_2)
    assert user_1.following?(user_2)
    user_1.unfollow(user_2)
    assert_not user_1.following?(user_2)
  end

  test "feed should have the right posts" do
    # 1 follows 2 but not follows 3 => can only see 2's post on his feed
    user_1 = users(:nsqa) 
    user_2 = users(:nsqa2)
    user_3 = users(:user_10)
    # Posts from followed user
    user_2.microposts.each do |post_following|
      assert user_1.feed.include?(post_following)
    end

    # Posts from self
    user_1.microposts.each do |post_self|
      assert user_1.feed.include?(post_self)
    end

    # Posts from unfollowed user
    user_3.microposts.each do |post_unfollowed|
      assert_not user_1.feed.include?(post_unfollowed)
    end
  end

end
