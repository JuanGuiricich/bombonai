require 'rails_helper'

RSpec.feature "User Sign Ins", type: :feature do
  let!(:user) { User.create(email: 'user@example.com', password: 'password123') }

  scenario 'user signs in successfully' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end
end
