require "test_helper"

class DecryptControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get decrypt_new_url
    assert_response :success
  end

  test "should get show" do
    get decrypt_show_url
    assert_response :success
  end
end
