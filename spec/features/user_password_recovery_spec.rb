require 'rails_helper'

RSpec.feature "Password Recovery", type: :feature do
  describe 'Password Recovery' do
    let!(:user) { User.create!(username: 'this_is_a_test', email: 'test@gmail.com', password: 'password', password_confirmation: 'password') }

    it 'user requests password recovery' do
      visit new_user_password_path
      fill_in 'Email', with: user.email
      click_button 'Send me reset password instructions'
      expect(page).to have_content('You will receive an email with instructions on how to reset your password in a few minutes.')
    end
  end
end
