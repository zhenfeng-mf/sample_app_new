require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  # 
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'layout links when not logged in' do
    get root_path
    assert_template 'static_pages/home'
    # Checking for the existence of a specific link
    # by specifying the a tag and the href attribute as options.
    # Rails automatically replaces the question mark ? with root_path
    # count: 2 verifies the exact number of Home page links
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path

    # Link for not logged in visitors
    assert_select 'a[href=?]', login_path

    # Link for logged in  users 
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', edit_user_path(@user), count: 0

    get contact_path
    assert_select 'title', full_title('Contact')
  end

  test 'layout links when logged in' do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path

    # Link for not logged in visitors
    assert_select 'a[href=?]', login_path, count: 0

    # Link for logged in  users 
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)

    get contact_path
    assert_select 'title', full_title('Contact')
  end

  test 'signup page access' do
    get signup_path
    assert_select 'title', full_title('Sign up')
  end

end
