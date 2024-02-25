class Server < ApplicationRecord
  @last_server_id ||= 0

  def self.next_server
    next_server = Server.where('id > ?', @last_server_id).order(:id).first || Server.order(:id).first
    puts "Next Server Selected: #{next_server.name}"

    @last_server_id = next_server.id
    next_server
  end
end
