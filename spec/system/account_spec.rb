require 'rails_helper'

RSpec.describe 'Account' do
  describe 'registration' do
    it 'user can register for an account' do
      visit root_path

      click_on I18n.t('public.landing_page.show.register')

      within '#new_user' do
        fill_in 'user_email', with: 'test@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_on I18n.t('public.landing_page.show.register')
      end

      confirmation_path = ActionMailer::Base.deliveries.last.body.match(/"(http:.*)"/)[1]
      visit confirmation_path

      expect(page).to have_selector('.notice', text: I18n.t('devise.confirmations.confirmed'))
    end
  end
end
