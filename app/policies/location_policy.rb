# frozen_string_literal: true

class LocationPolicy < ApplicationPolicy
  def new?
    record.game.created_by_id == user.id
  end

  def create?
    record.game.created_by_id == user.id
  end

  def show?
    record.game.created_by_id == user.id
  end

  def edit?
    record.game.created_by_id == user.id
  end

  def update?
    record.game.created_by_id == user.id
  end

  def destroy?
    record.game.created_by_id == user.id
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
