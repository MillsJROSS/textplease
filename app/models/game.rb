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


class Game < ApplicationRecord
  belongs_to :created_by, class_name: "User"

  has_many :locations

  validates :name, uniqueness: { scope: :created_by_id }, presence: true
end
