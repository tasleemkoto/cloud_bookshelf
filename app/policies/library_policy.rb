class LibraryPolicy < ApplicationPolicy
  # Policy for libraries, managing access based on membership or admin roles.

  # Allows a user to access the admin verification form
  def admin_dashboard_form?
    user.library_users.exists?(library: record)
    # Checks if the current user is a member of the library (`record`).
    # - `record`: The library being accessed.
    # Returns `true` if the user is a member, allowing access to the admin verification form.
  end

  # Allows a user to access the user dashboard if they are part of the library
  def user_dashboard?
    user.library_users.exists?(library: record)
    # Checks if the user is a member of the library (`record`).
    # If true, the user can access the user-specific dashboard.
  end

  # Allows a user to access the admin dashboard if they are an admin of the library
  def admin_dashboard?
    user.library_users.exists?(library: record, is_admin: true)
    # Checks if the user is an admin of the library (`record`).
    # If true, the user can access the admin-specific dashboard.
  end

  # Allows a user to view the library if they are a member
  def show?
    user.library_users.exists?(library: record) || user.library == record
    # Determines if the user can view the library details.
    # Returns `true` if the user is a member of the library (`record`).
  end

  # Allows any logged-in user to create a new library
  def create?
    user.present?
    # Any logged-in user can create a new library.
    # Returns `true` if the `user` is logged in.
  end

  # Allows admins of the library to update the library
  def update?
    user_is_admin?
    # Calls the `user_is_admin?` helper method to check if the user is an admin.
    # Only admins of the library are allowed to update it.
  end

  # Allows admins of the library to delete the library
  def destroy?
    user_is_admin?
    # Calls the `user_is_admin?` helper method to check if the user is an admin.
    # Only admins of the library are allowed to delete it.
  end

  private

  # Helper method to check if the current user is an admin of the library
  def user_is_admin?
    record.library_users.exists?(user: user, is_admin: true)
    # Checks if there is a `LibraryUser` record for the given `library` (`record`)
    # where the `user` is marked as `is_admin: true`.
    # Returns `true` if the user is an admin of the library.
  end

  # Scope to restrict access to libraries based on membership
  class Scope < Scope
    def resolve
      # Only return libraries the user is part of
      scope.joins(:library_users).where(library_users: { user_id: user.id })
      # Filters libraries (`scope`) to include only those where the user is a member.
      # Joins the `library_users` table and checks if the `user_id` matches the current user's ID.
    end
  end
end
