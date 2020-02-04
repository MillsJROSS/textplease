# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Games", type: :request, sign_in: :user do
  describe "GET /games" do
    it "shows only games for current_user" do
      other_user = create(:user)

      4.times { |i| create(:game, name: "Game #{i}", created_by: @user) }
      3.times { |i| create(:game, name: "Game #{i}", created_by: other_user) }

      get games_path

      expect(response).to have_http_status(200)
      expect(response.body).to have_selector(".games")
      expect(response.body).to have_selector(".game", count: 4)
    end
  end

  describe "POST /games" do
    it "saves valid games" do
      expect {
        post games_path, params: { game: { name: "New Game", created_by_id: @user.id } }
      }.to change { Game.count }.by(1)

      expect(response).to redirect_to(games_path)
      expect(flash.notice).to eq(t("games.create.success"))
    end

    it "prevents tampering with created_by_id" do
      other_user = create(:user)
      expect {
        post games_path, params: { game: { name: "New Game", created_by_id: other_user.id } }
      }.to change { Game.count }.by(0)

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end

    it "handles errors xhr true" do
      expect {
        post games_path, params: { game: { name: "", created_by_id: @user.id } }, xhr: true
      }.to change { Game.count }.by(0)

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end

    it "handles errors xhr false" do
      expect {
        post games_path, params: { game: { name: "", created_by_id: @user.id } }, xhr: false
      }.to change { Game.count }.by(0)

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end
  end

  describe "GET /games/new" do
    it "user can create new game" do
      get new_game_path

      expect(response).to have_http_status(200)
      expect(response.body)
        .to have_selector("#game_created_by_id[value=#{@user.id}]", visible: false)
    end
  end

  describe "GET /games/:id" do
    it "shows a game you own" do
      game = create(:game, created_by: @user, name: "Unique Name")

      get game_path(game)

      expect(response).to have_http_status(200)
      expect(response.body).to have_selector(".game", text: "Unique Name")
    end

    it "errors for games from another user" do
      other_user = create(:user)
      game = create(:game, created_by: other_user)

      get game_path(game)

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end
  end

  describe "GET /games/:id/edit" do
    it "goes to edit page" do
      game = create(:game, created_by: @user)

      get edit_game_path(game)

      expect(response).to have_http_status(200)
      expect(response.body).to have_selector("form#game_#{game.id}")
    end

    it "won't let you edit other users game" do
      other_user = create(:user)
      game = create(:game, created_by: other_user)

      get edit_game_path(game)

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end
  end

  describe "PUT /games/:id" do
    it "updates valid input" do
      game = create(:game, created_by: @user)

      put game_path(game), params: { game: { name: "Change the name" } }

      expect(response).to redirect_to(game_path(game))
      expect(flash.notice).to eq(t("games.update.success"))
    end

    it "fails on invalid input xhr true" do
      game = create(:game, created_by: @user)

      put game_path(game), params: { game: { name: "" } }, xhr: true

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end

    it "fails on invalid input xhr false" do
      game = create(:game, created_by: @user)

      put game_path(game), params: { game: { name: "" } }, xhr: false

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end

    it "prevents you from editing another users game" do
      other_user = create(:user)
      game = create(:game, created_by: other_user)

      put game_path(game), params: { game: { name: "Change Name" } }

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end
  end

  describe "DELETE /games/:id" do
    it "allows user to delete their game" do
      game = create(:game, created_by: @user)

      expect {
        delete game_path(game)
      }.to change { Game.count }.by(-1)

      expect(response).to redirect_to(games_path)
      expect(flash.notice).to eq(t("games.destroy.success"))
    end

    it "prevents user from deleting other users game" do
      other_user = create(:user)
      game = create(:game, created_by: other_user)

      expect {
        delete game_path(game)
      }.not_to(change { Game.count })

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end

    it "informs user on destroy failure" do
      game = create(:game, created_by: @user)
      allow(game).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      allow(Game).to receive(:find).and_return(game)

      expect {
        delete game_path(game)
      }.to raise_error ActiveRecord::RecordNotDestroyed
    end
  end
end
