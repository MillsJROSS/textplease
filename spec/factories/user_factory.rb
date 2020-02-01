# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "email#{n}@example.com"
    end
    password { "password" }

    trait :confirmed do
      confirmed_at { 1.day.ago }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
