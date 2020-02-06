# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage Location - ", sign_in: :user, game_locations: true  do
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

    # View Location
    click_on location_name

    # Edit Location
    click_on t("global.edit")
    changed_location_name = "#{location_name}_change"
    within "#location_#{Location.last.id}" do
      fill_in t("activerecord.attributes.location.name"), with: changed_location_name
      click_on t("global.submit")
    end

    # View Change
    expect(page).to have_selector(".location", text: changed_location_name)

    # Delete Location
    click_on t("global.delete")

    expect(page).not_to have_selector(".location", text: changed_location_name)
  end
end
