require "test_helper"

class Settings::PrioritiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get settings_priorities_index_url
    assert_response :success
  end

  test "should get new" do
    get settings_priorities_new_url
    assert_response :success
  end

  test "should get create" do
    get settings_priorities_create_url
    assert_response :success
  end

  test "should get edit" do
    get settings_priorities_edit_url
    assert_response :success
  end

  test "should get update" do
    get settings_priorities_update_url
    assert_response :success
  end

  test "should get destroy" do
    get settings_priorities_destroy_url
    assert_response :success
  end
end
