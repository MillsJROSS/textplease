# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage Location - ", sign_in: :user do
  it "lifecycle of a location" do
    location_name = "The Mountain"
    game = create(:game, created_by: @user)

    visit game_path(game)

    # Location Index
    click_on t("games.show.manage_location")
    within ".locations" do
      expect(page).not_to have_selector(".location", text: location_name)
    end

    # Create A Location
    click_on t("locations.index.create")
    within "#new_location" do
      fill_in t("activerecord.attributes.location.name"), with: location_name
      fill_in t("activerecord.attributes.location.enter_location_text"), with: "Long Message"
      click_on t("global.submit")
    end
    within ".locations" do
      expect(page).to have_selector(".location", text: location_name)
    end

    # within ".games" do
    #   expect(page).to have_selector(".game", text: game_name)
    # end
    #
    # # View Game
    # click_on game_name
    #
    # # Edit Game
    # click_on t("global.edit")
    # changed_game_name = "#{game_name}_change"
    # within "#game_#{Game.last.id}" do
    #   fill_in t("activerecord.attributes.game.name"), with: changed_game_name
    #   click_on t("global.submit")
    # end
    #
    # # View Change
    # expect(page).to have_selector(".game", text: changed_game_name)
    #
    # # Delete Game
    # click_on t("global.delete")
    #
    # expect(page).not_to have_selector(".game", text: changed_game_name)
  end
end
