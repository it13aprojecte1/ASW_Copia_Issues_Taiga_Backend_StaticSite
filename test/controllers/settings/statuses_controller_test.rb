require "test_helper"

class Settings::StatusesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get settings_statuses_index_url
    assert_response :success
  end

  test "should get new" do
    get settings_statuses_new_url
    assert_response :success
  end

  test "should get create" do
    get settings_statuses_create_url
    assert_response :success
  end

  test "should get edit" do
    get settings_statuses_edit_url
    assert_response :success
  end

  test "should get update" do
    get settings_statuses_update_url
    assert_response :success
  end

  test "should get destroy" do
    get settings_statuses_destroy_url
    assert_response :success
  end
end
