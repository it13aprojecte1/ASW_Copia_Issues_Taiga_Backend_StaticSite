# Estados iniciales
Status.create([
  { name: 'New', color: '#8A2BE2', is_closed: false, position: 1 },
  { name: 'In progress', color: '#1E90FF', is_closed: false, position: 2 },
  { name: 'Ready for test', color: '#FFA500', is_closed: false, position: 3 },
  { name: 'Closed', color: '#32CD32', is_closed: true, position: 4 },
  { name: 'Needs info', color: '#FF6347', is_closed: false, position: 5 }
])

# Prioridades iniciales
Priority.create([
  { name: 'Low', color: '#8BC34A', position: 1 },
  { name: 'Normal', color: '#3F51B5', position: 2 },
  { name: 'High', color: '#FF9800', position: 3 },
  { name: 'Critical', color: '#F44336', position: 4 }
])

# Tipos iniciales
IssueType.create([
  { name: 'Bug', color: '#F44336', position: 1 },
  { name: 'Feature', color: '#4CAF50', position: 2 },
  { name: 'Enhancement', color: '#2196F3', position: 3 },
  { name: 'Task', color: '#9C27B0', position: 4 }
])

# Severidades iniciales
Severity.create([
  { name: 'Wishlist', color: '#9E9E9E', position: 1 },
  { name: 'Minor', color: '#8BC34A', position: 2 },
  { name: 'Normal', color: '#3F51B5', position: 3 },
  { name: 'Important', color: '#FF9800', position: 4 },
  { name: 'Critical', color: '#F44336', position: 5 }
])