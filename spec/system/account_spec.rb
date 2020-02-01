require 'rails_helper'

RSpec.describe 'Account' do
  describe 'registration' do
    it 'user can register for an account' do
      visit root_path

      click_on I18n.t('public.landing_page.show.register')

      within '#new_user' do

      end
    end
  end
end
