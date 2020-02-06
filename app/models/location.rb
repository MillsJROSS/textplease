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

class Location < ApplicationRecord
  belongs_to :game

  validates :name, uniqueness: { scope: :game_id }, presence: true
end
