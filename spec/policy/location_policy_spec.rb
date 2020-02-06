require 'rails_helper'

RSpec.describe LocationPolicy, type: :policy, game_locations: true do
  before do
    @user = create(:user_with_game)
    @location = create(:location, game: @user.games.first)
    other_user = create(:user_with_game)
    @other_user_location = create(:location, game: other_user.games.first)
  end

  permissions :new?, :create?, :show?, :edit?, :update?, :destroy?  do
    it 'denies access to locations not owned by user' do
      expect(described_class).not_to permit(@user, @other_user_location)
    end

    it 'allows access to locations owned by user' do
      expect(described_class).to permit(@user, @location)
    end
  end
end
