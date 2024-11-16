class LibraryUserPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  
  def index?
    user.admin? # only admin can view library users
  end

  def show?
    user.admin? || library_user.user_id == user.id # user can view library only if he is the creator of the library
  end

  def create?
    user.admin? # admin can create a library_user
  end

  def update?
    user.admin? # can edit a library_user details
  end

  def destroy?
    user.admin? # can delete a library user
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
