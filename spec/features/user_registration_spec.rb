require 'rails_helper'

RSpec.feature "User Registrations", type: :feature do
  describe 'User Registrations' do
    it 'user signs up successfully' do
      visit new_user_registration_path
      fill_in 'Username', with: 'this_is_a_test'
      fill_in 'Email', with: 'test@gmail.com'
      fill_in 'Password', with: 'password', match: :prefer_exact
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end
end
