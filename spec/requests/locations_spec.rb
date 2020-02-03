# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Location", type: :request, sign_in: :user do
  describe "GET /location?game_id=:game_id" do
    it "shows only locations for specified game" do
      game = create(:game, created_by: @user)
      locations = create_list(:location, 3, game: game)
      other_game = create(:game, created_by: @user)
      create_list(:location, 4, game: other_game)

      get locations_path(game_id: game.id)

      expect(response).to have_http_status(200)
      expect(response.body).to have_selector(".locations")
      expect(response.body).to have_selector(".location", count: 3)
    end

    it "does not allow you to see other users locations" do
      other_user = create(:user)
      game = create(:game, created_by: other_user)
      locations = create_list(:location, 3, game: game)

      get locations_path(game_id: game.id)

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t('global.pundit.unauthorized'))
    end
  end

  describe "POST /locations?game_id=:game_id" do
    it "saves valid location" do
      game = create(:game, created_by: @user)

      expect {
        post locations_path, params: { location: { name: "New Game", game_id: game.id,
                                                   enter_location_text: 'Some text...'} }
      }.to change { game.locations.count }.by(1)

      expect(response).to redirect_to(locations_path(game_id: game.id))
      expect(flash.notice).to eq(t("locations.create.success"))
    end

    it "prevents user from using invalid game_id" do
      other_user = create(:user)
      other_game = create(:game, created_by: other_user)

      expect {
        post locations_path, params: { location: { name: "New Game", game_id: other_game.id,
                                                   enter_location_text: 'Some text...'} }
      }.to change { other_game.locations.count }.by(0)

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end

    it "handles errors xhr true" do
      game = create(:game, created_by: @user)

      expect {
        post locations_path, params: { location: { name: "", game_id: game.id,
                                                   enter_location_text: 'Some text...'} }, xhr: true
      }.to change { Game.count }.by(0)

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end

    it "handles errors xhr false" do
      game = create(:game, created_by: @user)

      expect {
        post locations_path, params: { location: { name: "", game_id: game.id,
                                                   enter_location_text: 'Some text...'} },
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

    it 'prevents user from trying to create new location with other user game' do
      other_user = create(:user)
      game = create(:game, created_by: other_user)

      get new_location_path(game_id: game.id)

      expect(response).to redirect_to(root_path)
    end
  end
  #
  # describe "GET /games/:id" do
  #   it "shows a game you own" do
  #     game = create(:game, created_by: @user, name: "Unique Name")
  #
  #     get game_path(game)
  #
  #     expect(response).to have_http_status(200)
  #     expect(response.body).to have_selector(".game", text: "Unique Name")
  #   end
  #
  #   it "errors for games from another user" do
  #     other_user = create(:user)
  #     game = create(:game, created_by: other_user)
  #
  #     get game_path(game)
  #
  #     expect(response).to redirect_to(root_path)
  #     expect(flash.alert).to eq(t("global.pundit.unauthorized"))
  #   end
  # end
  #
  # describe "GET /games/:id/edit" do
  #   it "goes to edit page" do
  #     game = create(:game, created_by: @user)
  #
  #     get edit_game_path(game)
  #
  #     expect(response).to have_http_status(200)
  #     expect(response.body).to have_selector("form#game_#{game.id}")
  #   end
  # end
  #
  # describe "PUT /games/:id" do
  #   it "updates valid input" do
  #     game = create(:game, created_by: @user)
  #
  #     put game_path(game), params: { game: { name: "Change the name" } }
  #
  #     expect(response).to redirect_to(game_path(game))
  #     expect(flash.notice).to eq(t("games.update.success"))
  #   end
  #
  #   it "fails on invalid input xhr true" do
  #     game = create(:game, created_by: @user)
  #
  #     put game_path(game), params: { game: { name: "" } }, xhr: true
  #
  #     expect(response).to have_http_status(400)
  #     expect(flash.alert).to be_present
  #   end
  #
  #   it "fails on invalid input xhr false" do
  #     game = create(:game, created_by: @user)
  #
  #     put game_path(game), params: { game: { name: "" } }, xhr: false
  #
  #     expect(response).to have_http_status(400)
  #     expect(flash.alert).to be_present
  #   end
  #
  #   it "prevents you from editing another users game" do
  #     other_user = create(:user)
  #     game = create(:game, created_by: other_user)
  #
  #     put game_path(game), params: { game: { name: "Change Name" } }
  #
  #     expect(response).to redirect_to(root_path)
  #     expect(flash.alert).to eq(t("global.pundit.unauthorized"))
  #   end
  # end
  #
  # describe "DELETE /games/:id" do
  #   it "allows user to delete their game" do
  #     game = create(:game, created_by: @user)
  #
  #     expect {
  #       delete game_path(game)
  #     }.to change { Game.count }.by(-1)
  #
  #     expect(response).to redirect_to(games_path)
  #     expect(flash.notice).to eq(t("games.destroy.success"))
  #   end
  #
  #   it "prevents user from deleting other users game" do
  #     other_user = create(:user)
  #     game = create(:game, created_by: other_user)
  #
  #     expect {
  #       delete game_path(game)
  #     }.not_to(change { Game.count })
  #
  #     expect(response).to redirect_to(root_path)
  #     expect(flash.alert).to eq(t("global.pundit.unauthorized"))
  #   end
  #
  #   it "informs user on destroy failure" do
  #     game = create(:game, created_by: @user)
  #     allow(game).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
  #     allow(Game).to receive(:find).and_return(game)
  #
  #     expect {
  #       delete game_path(game)
  #     }.to raise_error ActiveRecord::RecordNotDestroyed
  #   end
  # end
end
