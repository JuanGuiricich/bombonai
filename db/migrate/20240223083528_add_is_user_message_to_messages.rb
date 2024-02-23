class AddIsUserMessageToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :is_user_message, :boolean
  end
end
