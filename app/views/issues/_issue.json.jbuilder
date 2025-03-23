json.extract! issue, :id, :subject, :content, :user_id, :created_at, :updated_at
json.issue_status issue.issue_status.name
json.issue_type issue.issue_type.name
json.issue_severity issue.issue_severity.name
json.issue_priority issue.issue_priority.name
json.url issue_url(issue, format: :json)
