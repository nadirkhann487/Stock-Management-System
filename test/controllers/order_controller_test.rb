require 'test_helper'

class OrderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get order_index_url
    assert_response :success
  end

  test "should get new" do
    get order_new_url
    assert_response :success
  end

  test "should get edit" do
    get order_edit_url
    assert_response :success
  end

  test "should get show" do
    get order_show_url
    assert_response :success
  end

  test "should get delete" do
    get order_delete_url
    assert_response :success
  end

end
