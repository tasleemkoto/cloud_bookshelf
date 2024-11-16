require "test_helper"

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get checkouts_index_url
    assert_response :success
  end

  test "should get new" do
    get checkouts_new_url
    assert_response :success
  end

  test "should get create" do
    get checkouts_create_url
    assert_response :success
  end

  test "should get edit" do
    get checkouts_edit_url
    assert_response :success
  end

  test "should get update" do
    get checkouts_update_url
    assert_response :success
  end
end
