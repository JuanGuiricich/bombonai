require 'rails_helper'

RSpec.feature "User Registrations", type: :feature do
  scenario 'user signs up successfully' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'password123', match: :prefer_exact
    fill_in 'Password confirmation', with: 'password123', match: :prefer_exact

    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
