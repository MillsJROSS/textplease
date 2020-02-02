class GamePolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    record.created_by == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(created_by: user)
    end
  end
end
