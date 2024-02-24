class ChatService
  include HTTParty
  base_uri 'http://35.204.143.204:5000'

  def self.send_message(api_request)
    server = Server.next_server
    base_uri server.url
    response = post('/v1/chat/completions', body: api_request.to_json, headers: { 'Content-Type' => 'application/json' })
    Rails.logger.info "API Response: #{response.body}"
    response
  end
end
