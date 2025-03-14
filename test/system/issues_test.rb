require "application_system_test_case"

class IssuesTest < ApplicationSystemTestCase
  setup do
    @issue = issues(:one)
  end

  test "visiting the index" do
    visit issues_url
    assert_selector "h1", text: "Issues"
  end

  test "should create issue" do
    visit issues_url
    click_on "New issue"

    fill_in "Content", with: @issue.content
    fill_in "Priority", with: @issue.priority
    fill_in "Severity", with: @issue.severity
    fill_in "State", with: @issue.state
    fill_in "Subject", with: @issue.subject
    fill_in "Type", with: @issue.type
    fill_in "User", with: @issue.user_id
    click_on "Create Issue"

    assert_text "Issue was successfully created"
    click_on "Back"
  end

  test "should update Issue" do
    visit issue_url(@issue)
    click_on "Edit this issue", match: :first

    fill_in "Content", with: @issue.content
    fill_in "Priority", with: @issue.priority
    fill_in "Severity", with: @issue.severity
    fill_in "State", with: @issue.state
    fill_in "Subject", with: @issue.subject
    fill_in "Type", with: @issue.type
    fill_in "User", with: @issue.user_id
    click_on "Update Issue"

    assert_text "Issue was successfully updated"
    click_on "Back"
  end

  test "should destroy Issue" do
    visit issue_url(@issue)
    click_on "Destroy this issue", match: :first

    assert_text "Issue was successfully destroyed"
  end
end
