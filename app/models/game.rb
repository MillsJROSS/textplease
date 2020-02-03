# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :created_by, class_name: "User"

  validates :name, uniqueness: { scope: :created_by_id }, presence: true
end
