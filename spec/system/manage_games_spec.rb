# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage Game - ", sign_in: :user do
  it "creating a game" do
    visit root_path

    click_on t("layouts.navigation.my_games")

    within ".games" do
      expect(page).not_to have_selector(".game", text: "New Game")
    end

    click_on t("games.index.create")

    within "#new_game" do
      fill_in t("activerecord.attributes.game.name"), with: "New Game"
      click_on t("global.submit")
    end

    within ".games" do
      expect(page).to have_selector(".game", text: "New Game")
    end

    click_on 'New Game'
  end
end
