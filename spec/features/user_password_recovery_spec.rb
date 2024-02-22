require 'rails_helper'

RSpec.feature "Password Recovery", type: :feature do
  let!(:user) { User.create(email: 'user@example.com', password: 'password123') }

  scenario 'user requests password recovery' do
    visit new_user_password_path

    fill_in 'Email', with: user.email
    click_button 'Send me reset password instructions'

    expect(page).to have_content('You will receive an email with instructions on how to reset your password in a few minutes.')
  end
end
