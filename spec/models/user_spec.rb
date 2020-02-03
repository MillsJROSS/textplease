# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#email" do
    it "must be present" do
      user = build(:user, email: "")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(t("errors.messages.blank"))
    end

    it "must be unique" do
      create(:user, email: "user@example.com")
      second_user = build(:user, email: "user@example.com")

      expect(second_user).not_to be_valid
      expect(second_user.errors[:email]).to include(t("errors.messages.taken"))
    end
  end

  describe '#games' do
    it 'gives us the list of games associated with user' do
      user = create(:user)
      games = create_list(:game, 5, created_by: user)

      expect(user.games.ids).to include(*games.map(&:id))
    end
  end
end
