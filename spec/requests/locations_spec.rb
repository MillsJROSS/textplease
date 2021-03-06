# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Location", type: :request, sign_in: :user, game_locations: true  do
  describe "GET /location?game_id=:game_id" do
    it "shows only locations for specified game" do
      game = create(:game, created_by: @user)
      create_list(:location, 3, game: game)
      other_game = create(:game, created_by: @user)
      create_list(:location, 4, game: other_game)

      get locations_path(game_id: game.id)

      expect(response).to have_http_status(200)
      expect(response.body).to have_selector(".locations")
      expect(response.body).to have_selector(".location", count: 3)
    end
  end

  describe "POST /locations?game_id=:game_id" do
    it "saves valid location" do
      game = create(:game, created_by: @user)

      expect {
        post locations_path, params: { location: { name: "New Game", game_id: game.id,
                                                   enter_location_text: "Some text..." } }
      }.to change { game.locations.count }.by(1)

      expect(response).to redirect_to(locations_path(game_id: game.id))
      expect(flash.notice).to eq(t("locations.create.success"))
    end

    it "handles errors xhr true" do
      game = create(:game, created_by: @user)

      expect {
        post locations_path, params: { location: { name: "", game_id: game.id,
                                                   enter_location_text: "Some text..." } },
                             xhr: true
      }.to change { Game.count }.by(0)

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end

    it "handles errors xhr false" do
      game = create(:game, created_by: @user)

      expect {
        post locations_path, params: { location: { name: "", game_id: game.id,
                                                   enter_location_text: "Some text..." } },
                             xhr: false
      }.to change { Game.count }.by(0)

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end
  end

  describe "GET /locations/new?game_id=:game_id" do
    it "user can create new location" do
      game = create(:game, created_by: @user)

      get new_location_path(game_id: game.id)

      expect(response).to have_http_status(200)
      expect(response.body)
        .to have_selector("#location_game_id[value=#{game.id}]", visible: false)
    end
  end

  describe "GET /location/:id" do
    it "shows a location you own" do
      game = create(:game, created_by: @user)
      location = create(:location, game: game, name: "Unique Name")

      get location_path(location)

      expect(response).to have_http_status(200)
      expect(response.body).to have_selector(".location", text: "Unique Name")
    end
  end

  describe "GET /location/:id/edit" do
    it "goes to edit page" do
      game = create(:game, created_by: @user)
      location = create(:location, game: game)

      get edit_location_path(location)

      expect(response).to have_http_status(200)
      expect(response.body).to have_selector("form#location_#{location.id}")
    end
  end

  describe "PUT /locations/:id" do
    it "updates valid input" do
      game = create(:game, created_by: @user)
      location = create(:location, game: game)

      put location_path(location), params: { location: { name: "Change the name" } }

      expect(response).to redirect_to(location_path(location))
      expect(flash.notice).to eq(t("locations.update.success"))
    end

    it "fails on invalid input xhr true" do
      game = create(:game, created_by: @user)
      location = create(:location, game: game)

      put location_path(location), params: { location: { name: "" } }, xhr: true

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end

    it "fails on invalid input xhr false" do
      game = create(:game, created_by: @user)
      location = create(:location, game: game)

      put location_path(location), params: { location: { name: "" } }, xhr: false

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end
  end

  describe "DELETE /locations/:id" do
    it "allows user to delete their location" do
      game = create(:game, created_by: @user)
      location = create(:location, game: game)

      expect {
        delete location_path(location)
      }.to change { Location.count }.by(-1)

      expect(response).to redirect_to(locations_path(game_id: game.id))
      expect(flash.notice).to eq(t("locations.destroy.success"))
    end

    it "informs user on destroy failure" do
      game = create(:game, created_by: @user)
      location = create(:location, game: game)
      allow(location).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      allow(Location).to receive(:find).and_return(location)

      expect {
        delete location_path(location)
      }.to raise_error ActiveRecord::RecordNotDestroyed
    end
  end
end
