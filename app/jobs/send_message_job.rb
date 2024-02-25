class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(user_id, message_content)
  user = User.find(user_id)
  message_history = user.messages.order(created_at: :asc)

  messages_conversation = message_history.map do |message|
    {
      role: message.is_user_message ? "user" : "ai",
      content: message.content
    }
  end

  messages_conversation << { role: "user", content: message_content }

  api_request = {
    your_name: user.username,
    user_input: message_content,
    name1: user.username,
    name2: "Tamara",
    context: "You are Tamara an Argentinian girl that is fan of Boca Juniors and loves to party hard.",
    character: "Example",
    messages: messages_conversation
  }

  response = ChatService.send_message(api_request)

    if response.success?
      parsed_response = JSON.parse(response.body)
      ai_message_content = parsed_response["choices"][0]["message"]["content"]

      message = Message.create!(
        user_id: user_id,
        content: ai_message_content,
        is_user_message: false
      )
      broadcast_message(user_id, message)
    end
  end

  def broadcast_message(user_id, message)
    Turbo::StreamsChannel.broadcast_append_to "messages_#{user_id}",
                                            target: "messages_#{user_id}",
                                            partial: "messages/message",
                                            locals: { message: message }
  end
end
