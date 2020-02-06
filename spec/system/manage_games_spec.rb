# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage Game - ", sign_in: :user, games: true do
  it "lifecycle of a game" do
    game_name = "New Game"

    visit root_path
    click_on t("layouts.navigation.my_games")
    within ".games" do
      expect(page).not_to have_selector(".game", text: game_name)
    end

    # Create A Game
    click_on t("games.index.create")
    within "#new_game" do
      fill_in t("activerecord.attributes.game.name"), with: game_name
      click_on t("global.submit")
    end
    within ".games" do
      expect(page).to have_selector(".game", text: game_name)
    end

    # View Game
    click_on game_name

    # Edit Game
    click_on t("global.edit")
    changed_game_name = "#{game_name}_change"
    within "#game_#{Game.last.id}" do
      fill_in t("activerecord.attributes.game.name"), with: changed_game_name
      click_on t("global.submit")
    end

    # View Change
    expect(page).to have_selector(".game", text: changed_game_name)

    # Delete Game
    click_on t("global.delete")

    expect(page).not_to have_selector(".game", text: changed_game_name)
  end
end
