module IssuesHelper
  # Helper method to determine the appropriate badge color for a status
  def issue_status_color(status)
    case status.name.downcase
    when 'new'
      'primary'
    when 'in progress'
      'info'
    when 'resolved'
      'success'
    when 'closed'
      'secondary'
    else
      'primary'
    end
  end
end
