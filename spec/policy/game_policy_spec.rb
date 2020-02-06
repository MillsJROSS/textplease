require 'rails_helper'

RSpec.describe GamePolicy, type: :policy, games: true do
  before do
    @user = create(:user)
    other_user = create(:user)
    @game = create(:game, created_by: @user)
    @other_game = create(:game, created_by: other_user)
  end

  permissions :new?, :create?, :show?, :edit?, :update?, :destroy?  do
    it 'denies access to game not owned by user' do
      expect(described_class).not_to permit(@user, @other_game)
    end

    it 'allows access to locations owned by user' do
      expect(described_class).to permit(@user, @game)
    end
  end
end
