class LibraryUserPolicy < ApplicationPolicy
  # Determines if the user can remove a library user from the library
  def destroy?
    user_is_admin?
    # Only library admins can remove a user (delete a LibraryUser record).
    # Calls the private `user_is_admin?` method to check if the current user is an admin of the library.
  end

  def new?
    record.library == user.library
  end

  def create?
    true
  end
  
  private

  # Checks if the user is an admin of the library associated with the LibraryUser record
  def user_is_admin?
    record.library.library_users.exists?(user_id: user.id, is_admin: true)
    # `record`: The LibraryUser instance being acted upon.
    # `record.library`: The library associated with this LibraryUser record.
    # `library.library_users.exists?`: Checks if there is a LibraryUser record where:
    # - The `user_id` matches the current user's ID.
    # - The `is_admin` field is `true`.
    # Returns `true` if the user is an admin of the library.
  end

  # Scope class to determine which LibraryUser records a user can access
  class Scope < Scope
    def resolve
      scope.all
      # By default, returns all LibraryUser records.
      # You can modify this to restrict results based on the current user's role or membership.
      # Example:
      # `scope.where(library: user.libraries)` to show only LibraryUser records for libraries the user belongs to.
    end
  end
end
