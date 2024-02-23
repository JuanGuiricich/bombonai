class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(user_id, message_content)
    api_request = {
      your_name: User.find(user_id).username,
      user_input: message_content,
      name1: User.find(user_id).username,
      name2: "Helena",
      context: "You are a friend that is a fan of Boca Juniors, please in your responses bring a fact about Boca Juniors.",
      character: "Example",
      messages: [
        {
          role: "user",
          content: message_content
        }
      ]
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
                                            target: "messages_#{user_id}", # Ensure this matches your subscription in the view
                                            partial: "messages/message",
                                            locals: { message: message }
  end
end
