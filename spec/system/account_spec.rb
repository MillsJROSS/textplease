# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account" do
  describe "registration" do
    it "user can register for an account" do
      visit root_path

      click_on t("layouts.navigation.register")

      within "#new_user" do
        fill_in "user_email", with: "test@example.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_on t("layouts.navigation.register")
      end

      confirmation_path = ActionMailer::Base.deliveries.last.body.match(/"(http:.*)"/)[1]
      visit confirmation_path

      expect(page).to have_selector(".notice", text: t("devise.confirmations.confirmed"))
    end
  end

  describe "signing in" do
    it "confirmed user can sign in" do
      user = create(:user, :confirmed)

      visit root_path

      expect(page).not_to have_selector("a", text: t("layouts.navigation.sign_out"))
      click_on t("layouts.navigation.sign_in")

      within "#new_user" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "password"
        click_on t("layouts.navigation.sign_in")
      end

      expect(page).to have_selector(".notice", text: t("devise.sessions.signed_in"))
    end

    it "unconfirmed user cannot sign in" do
      user = create(:user, :unconfirmed)

      visit root_path

      click_on t("layouts.navigation.sign_in")

      within "#new_user" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "password"
        click_on t("layouts.navigation.sign_in")
      end

      expect(page).to have_selector(".alert", text: t("devise.failure.unconfirmed"))
    end

    it "locks user out after configured times" do
      original_max_attempts = Rails.application.config.devise.maximum_attempts
      Rails.application.config.devise.maximum_attempts = 2
      user = create(:user, :confirmed)

      visit root_path

      click_on t("layouts.navigation.sign_in")

      within "#new_user" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "badpassword"
        click_on t("layouts.navigation.sign_in")
      end

      expect(page).to have_selector(".alert", text: t("devise.failure.last_attempt"))

      within "#new_user" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "badpassword"
        click_on t("layouts.navigation.sign_in")
      end

      expect(page).to have_selector(".alert", text: t("devise.failure.locked"))
      Rails.application.config.devise.maximum_attempts = original_max_attempts
    end
  end

  describe "signing out" do
    it "goes back to root path" do
      sign_in create(:user, :confirmed)

      visit root_path

      expect(page).not_to have_selector("a", text: t("layouts.navigation.sign_in"))
      expect(page).not_to have_selector("a", text: t("layouts.navigation.register"))
      click_on t("layouts.navigation.sign_out")

      expect(page).to have_selector(".notice", text: t("devise.sessions.signed_out"))
      expect(current_path).to eq(root_path)
    end
  end
end
