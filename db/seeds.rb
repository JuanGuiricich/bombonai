puts "Clearing existing data..."
Profile.delete_all
Server.delete_all

puts "Seeding servers..."
server_1 = Server.find_or_create_by(name: 'server-1') do |server|
  server.url = 'http://35.204.143.204:5000'
end
puts "Server 1 #{server_1.persisted? ? 'found or created' : 'failed to create'}."

server_2 = Server.find_or_create_by(name: 'server-2') do |server|
  server.url = 'http://35.204.143.204:5000'
end
puts "Server 2 #{server_2.persisted? ? 'found or created' : 'failed to create'}."

puts "Seeding profiles..."
100_000.times do
  Profile.create!(
    name: Faker::Name.name,
    gender: Faker::Gender.binary_type,
    category: Faker::Book.genre
  )
end

puts "Seeding completed."
