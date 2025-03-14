json.extract! issue, :id, :subject, :content, :state, :type, :severity, :priority, :user_id, :created_at, :updated_at
json.url issue_url(issue, format: :json)
