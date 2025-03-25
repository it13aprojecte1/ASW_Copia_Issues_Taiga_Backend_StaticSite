require "test_helper"

class Settings::SeveritiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get settings_severities_index_url
    assert_response :success
  end

  test "should get new" do
    get settings_severities_new_url
    assert_response :success
  end

  test "should get create" do
    get settings_severities_create_url
    assert_response :success
  end

  test "should get edit" do
    get settings_severities_edit_url
    assert_response :success
  end

  test "should get update" do
    get settings_severities_update_url
    assert_response :success
  end

  test "should get destroy" do
    get settings_severities_destroy_url
    assert_response :success
  end
end
