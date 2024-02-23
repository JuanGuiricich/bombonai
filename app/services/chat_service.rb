class ChatService
  include HTTParty
  base_uri 'http://35.204.143.204:5000'

  def self.send_message(payload)
    response = post('/v1/chat/completions', body: payload.to_json, headers: { 'Content-Type' => 'application/json' })
    Rails.logger.info "API Response: #{response.body}"
    response
  end
end



# payload = {
#   your_name: "Test User",
#   user_input: "Hello, just testing!",
#   name1: "Test User",
#   name2: "AI",
#   greeting: "Hello, what can I do for you?",
#   context: "Testing the chat service.",
#   character: "Example",
#   messages: [
#     {
#       role: "user",
#       content: "Hello, just testing!"
#     },
#     {
#       role: "assistant",
#       content: "Hello, what can I do for you?"
#     }
#   ]
# }

# response = ChatService.send_message(payload)
