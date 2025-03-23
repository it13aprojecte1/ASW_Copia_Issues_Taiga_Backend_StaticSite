# Crear estados
statuses = [
  { name: 'New', position: 1 },
  { name: 'Open', position: 2 },
  { name: 'On Hold', position: 3 },
  { name: 'Resolved', position: 4 },
  { name: 'Closed', position: 5 }
]

statuses.each do |status|
  IssueStatus.find_or_create_by!(name: status[:name]) do |s|
    s.position = status[:position]
  end
end

# Crear tipos
types = [
  { name: 'Bug', color: '#FF0000', position: 1 },
  { name: 'Enhancement', color: '#0000FF', position: 2 },
  { name: 'Feature', color: '#00FF00', position: 3 },
  { name: 'Task', color: '#FFFF00', position: 4 }
]

types.each do |type|
  IssueType.find_or_create_by!(name: type[:name]) do |t|
    t.color = type[:color]
    t.position = type[:position]
  end
end

# Crear severidades
severities = [
  { name: 'Wishlist', color: '#C0C0C0', position: 1 },
  { name: 'Minor', color: '#00FF00', position: 2 },
  { name: 'Normal', color: '#FFFF00', position: 3 },
  { name: 'Important', color: '#FFA500', position: 4 },
  { name: 'Critical', color: '#FF0000', position: 5 }
]

severities.each do |severity|
  IssueSeverity.find_or_create_by!(name: severity[:name]) do |s|
    s.color = severity[:color]
    s.position = severity[:position]
  end
end

# Crear prioridades
priorities = [
  { name: 'Low', color: '#00FF00', position: 1 },
  { name: 'Normal', color: '#FFFF00', position: 2 },
  { name: 'High', color: '#FF0000', position: 3 }
]

priorities.each do |priority|
  IssuePriority.find_or_create_by!(name: priority[:name]) do |p|
    p.color = priority[:color]
    p.position = priority[:position]
  end
end