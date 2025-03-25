require "test_helper"

class Settings::IssueTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get settings_issue_types_index_url
    assert_response :success
  end

  test "should get new" do
    get settings_issue_types_new_url
    assert_response :success
  end

  test "should get create" do
    get settings_issue_types_create_url
    assert_response :success
  end

  test "should get edit" do
    get settings_issue_types_edit_url
    assert_response :success
  end

  test "should get update" do
    get settings_issue_types_update_url
    assert_response :success
  end

  test "should get destroy" do
    get settings_issue_types_destroy_url
    assert_response :success
  end
end
