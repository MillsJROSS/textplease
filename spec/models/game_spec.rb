# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id            :bigint           not null, primary key
#  name          :string
#  created_by_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe Game, type: :model, games: true do
  describe "#name" do
    it "can not be blank" do
      user = create(:user)
      game = build(:game, name: " ", created_by: user)

      expect(game).not_to be_valid
      expect(game.errors[:name]).to include(t("errors.messages.blank"))
    end

    it "is unique for each user" do
      user = create(:user)
      create(:game, name: "One", created_by: user)

      duplicate_name = build(:game, name: "One", created_by: user)

      expect(duplicate_name).not_to be_valid
      expect(duplicate_name.errors[:name]).to include(t("errors.messages.taken"))
    end

    it "allows different users to create the same name" do
      user = create(:user)
      user2 = create(:user)
      create(:game, name: "One", created_by: user)

      game_w_user2 = build(:game, name: "One", created_by: user2)

      expect(game_w_user2).to be_valid
    end
  end

  describe "#locations" do
    it "can retrieve locations" do
      user = create(:user_with_game)
      game = user.games.first
      locations = create_list(:location, 5, game: game)

      expect(game.reload.locations).to include(*locations)
    end
  end
end
