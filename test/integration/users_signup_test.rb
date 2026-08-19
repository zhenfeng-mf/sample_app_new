require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'

    # assert_select(arg1) tests is there at least one element matching arg1 CSS selector
    # assert_select(arg1, arg2) tests the value inside arg1 is equal to arg2
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end

  test 'valid signup information' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    follow_redirect!
    # assert_template 'users/show'
    # assert_not flash.empty?
    # assert is_logged_in?

    # get root_path
    # assert flash.empty? # test flash msg is self wiped out after user leaving the page.user
  end
end
