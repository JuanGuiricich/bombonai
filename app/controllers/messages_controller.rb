class MessagesController < ApplicationController

  before_action :authenticate_user!

  def index
    @messages = current_user.messages
    @message = Message.new
  end

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to messages_path, notice: 'Message sent!' }
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:user_name, :content)
  end
end
