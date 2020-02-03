class LocationPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  class Scope
    attr_reader :user, :game

    def initialize(user, game)
      @user = user
      @game = game
    end

    def resolve
      game.locations
    end
  end
end
