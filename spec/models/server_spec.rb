require 'rails_helper'

RSpec.describe Server, type: :model do
  describe '.next_server' do
    it 'alternates between servers' do
      server1 = Server.create!(name: 'server-1', url: 'http://example.com')
      server2 = Server.create!(name: 'server-2', url: 'http://example.com')

      expect(Server.next_server).to eq(server1)
      expect(Server.next_server).to eq(server2)
      expect(Server.next_server).to eq(server1)
    end
  end
end
