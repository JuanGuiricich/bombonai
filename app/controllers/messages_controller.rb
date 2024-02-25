
class MessagesController < ApplicationController

  before_action :authenticate_user!

  def index
    @messages = current_user.messages
    @message = Message.new
  end

  def create
    @message = current_user.messages.build(message_params.merge(is_user_message: true))

    if @message.save
      broadcast_user_message(@message)
      SendMessageJob.perform_later(current_user.id, @message.content)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to messages_path, notice: 'Message sent!' }
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def broadcast_user_message(message)
    Turbo::StreamsChannel.broadcast_append_to "messages_#{message.user_id}",
                                             target: "messages_#{message.user_id}",
                                             partial: "messages/message",
                                             locals: { message: message }
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
