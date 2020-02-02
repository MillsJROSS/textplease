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
      expect do
        post games_path, params: { game: { name: "New Game", created_by_id: @user.id } }
      end.to change { Game.count }.by(1)

      expect(response).to redirect_to(games_path)
      expect(flash.notice).to eq(t("games.create.success"))
    end

    it "prevents tampering with created_by_id" do
      other_user = create(:user)
      expect do
        post games_path, params: { game: { name: "New Game", created_by_id: other_user.id } }
      end.to change { Game.count }.by(0)

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end

    it "handles errors xhr true" do
      expect do
        post games_path, params: { game: { name: "", created_by_id: @user.id } }, xhr: true
      end.to change { Game.count }.by(0)

      expect(response).to have_http_status(400)
      expect(flash.alert).to be_present
    end

    it "handles errors xhr false" do
      expect do
        post games_path, params: { game: { name: "", created_by_id: @user.id } }, xhr: false
      end.to change { Game.count }.by(0)

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

  describe "GET /game/:id" do
    it "shows a game you own" do
      game = create(:game, created_by: @user)

      get game_path(game)

      expect(response).to have_http_status(200)
    end

    it "errors for games from another user" do
      other_user = create(:user)
      game = create(:game, created_by: other_user)

      get game_path(game)

      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq(t("global.pundit.unauthorized"))
    end
  end
end
