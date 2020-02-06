# frozen_string_literal: true

class GamePolicy < ApplicationPolicy
  def index?
    record.created_by == user
  end

  def new?
    create?
  end

  def create?
    record.created_by == user
  end

  def show?
    record.created_by == user
  end

  def edit?
    record.created_by == user
  end

  def update?
    record.created_by == user
  end

  def destroy?
    record.created_by == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(created_by: user)
    end
  end
end
