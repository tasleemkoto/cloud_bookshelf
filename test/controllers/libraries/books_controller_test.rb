require "test_helper"

class Libraries::BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get libraries_books_index_url
    assert_response :success
  end

  test "should get show" do
    get libraries_books_show_url
    assert_response :success
  end

  test "should get new" do
    get libraries_books_new_url
    assert_response :success
  end

  test "should get create" do
    get libraries_books_create_url
    assert_response :success
  end

  test "should get edit" do
    get libraries_books_edit_url
    assert_response :success
  end

  test "should get update" do
    get libraries_books_update_url
    assert_response :success
  end

  test "should get destroy" do
    get libraries_books_destroy_url
    assert_response :success
  end
end
