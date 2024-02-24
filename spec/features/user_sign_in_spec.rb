require 'rails_helper'

RSpec.feature "User Sign Ins", type: :feature do
  describe 'User Sign Ins' do
    let!(:user) { User.create!(username: 'this_is_a_test', email: 'test@gmail.com', password: 'password', password_confirmation: 'password') }

    it 'user signs in successfully' do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end
  end
end
