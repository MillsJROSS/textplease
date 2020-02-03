# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    sequence :name do |i|
      "Name #{i}"
    end
    created_by { "" }
  end
end
