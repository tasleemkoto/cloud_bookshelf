class WishlistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Limit wishlists to those that belong to the user's libraries
      scope.where(library: user.libraries)
    end
  end

  def index?
    library_member?
  end

  def create?
    library_member?
  end

  def destroy?
    library_member?
  end

  private

  def library_member?
    user.libraries.exists?(id: record.library_id)
  end
end
