require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: {user: {name: "",
                                       email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar"}}
    end
    assert_template "users/new"
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end
end
