# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id                  :bigint           not null, primary key
#  name                :string
#  game_id             :bigint           not null
#  enter_location_text :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require "rails_helper"

RSpec.describe Location, type: :model, game_locations: true  do
  describe "#name" do
    it "does not allow an identical name in the same game" do
      user = create(:user_with_game)
      game = user.games.first
      create(:location, name: "Unique Name", game: game)
      location = build(:location, name: "Unique Name", game: game)

      expect(location).not_to be_valid
      expect(location.errors[:name]).to include(t("errors.messages.taken"))
    end

    it "does allow identical name in different games" do
      user = create(:user_with_game)
      game = user.games.first
      other_game = create(:game, created_by: user)
      create(:location, name: "Unique Name", game: game)
      location = build(:location, name: "Unique Name", game: other_game)

      expect(location).to be_valid
    end

    it "does not allow blank name" do
      location = build(:location, name: " ")

      expect(location).not_to be_valid
      expect(location.errors[:name]).to include(t("errors.messages.blank"))
    end
  end
end
