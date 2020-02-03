FactoryBot.define do
  factory :location do
    sequence :name do |i|
      "Name #{i}"
    end
    game { nil }
    enter_location_text { "A long message..." }
  end
end
