require 'rails_helper'

RSpec.describe SendMessageJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user) { User.create!(username: 'this_is_a_test', email: 'test@gmail.com', password: 'password') }

  before do
    allow(ChatService).to receive(:send_message) { OpenStruct.new(success?: true, body: '{"choices":[{"message":{"content":"Hi, this is AI responding"}}]}') }
  end

  it 'sends a message to the ChatService and processes the response' do
    expect {
      perform_enqueued_jobs do
        SendMessageJob.perform_later(user.id, "Hello, AI")
      end
    }.to change(Message, :count).by(1)

    new_message = Message.last
    expect(new_message.content).to eq("Hi, this is AI responding")
    expect(new_message.user_id).to eq(user.id)
    expect(new_message.is_user_message).to be_falsey
  end
end
