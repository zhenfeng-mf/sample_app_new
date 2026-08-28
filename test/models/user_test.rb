require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Test user',
      email: 'user@test.com',
      password: 'foobarrr',
      password_confirmation: 'foobarrr'
    )
  end

  test 'user should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    # validates(:name, {presence: true}) checks :name.blank? not :name.empty?
    # Strings with only whitespaces is evaluates as blank. "   ".blank? => true
    @user.name = '   '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '  '
    assert_not @user.valid?
  end

  test 'name should not be longer than 50' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be longer than 255' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addressess' do
    valid_addresses = [
      'user@example.com',
      'USER@foo.COM',
      'A_US-ER@foo.bar.org',
      'first.last@foo.jp',
      'alice+bob@baz.cn'
    ]

    valid_addresses.each do |valid_email|
      @user.email = valid_email
      # assert(value_to_evaluate, optional_failure_message)
      # .inspect print out a more readable and debugging friendly literal of the object
      assert(@user.valid?, "#{valid_email.inspect} should be valid")
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = [
      'user@example,com',
      'user_at_foo.org',
      'user.name@example.',
      'foo@bar_baz.com',
      'foo@bar+baz.com'
    ]
    # The loop terminates whenever a single assertion fails.
    # The remaining elements in the array won't be looked at.
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not(@user.valid?, "#{invalid_address.inspect} should be invalid")
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'eamil addresses should be saved as lowercase' do
    mixed_case_email = 'Foo@ExaMple.Com'
    @user.email = mixed_case_email
    @user.save
    assert_equal(mixed_case_email.downcase, @user.reload.email)
  end

  test 'password should be present(nonblank)' do
    @user.password = ' ' * 8
    @user.password_confirmation = @user.password
    assert_not @user.valid?
  end

  test 'password should have a minimum length of 6' do
    @user.password = 'a' * 5
    @user.password_confirmation = @user.password
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
