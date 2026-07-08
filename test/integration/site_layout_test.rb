require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test 'layout links' do
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

    get contact_path
    assert_select 'title', full_title('Contact')
  end

  test 'signup page access' do
    get signup_path
    assert_select 'title', full_title('Sign up')
  end
end
