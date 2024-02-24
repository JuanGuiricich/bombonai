# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

server_1 = Server.find_or_create_by(name: 'server-1') do |server|
  server.url = 'http://35.204.143.204:5000'
end
puts "Server 1 #{server_1.persisted? ? 'found or created' : 'failed to create'}."

server_2 = Server.find_or_create_by(name: 'server-2') do |server|
  server.url = 'http://35.204.143.204:5000'
end
puts "Server 2 #{server_2.persisted? ? 'found or created' : 'failed to create'}."
