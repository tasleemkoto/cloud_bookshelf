class CheckoutPolicy < ApplicationPolicy
  # Determines if the user can view the list of checkouts
  def index?
    true
    # Allows all users (logged in or not) to view the index of checkouts.
    # Change this to `user.present?` if you want to restrict it to logged-in users.
  end

  # Determines if the user can create a new checkout
  def create?
    true
    # Allows all users to create a checkout.
    # This assumes that creating a checkout means reserving or borrowing a book,
    # which is typically open to all authenticated users. Update this to `user.present?`
    # if only logged-in users should be allowed.
  end

  # Determines if the user can update an existing checkout
  def update?
    user_is_admin?
    # Only a library admin can update a checkout.
    # Example: Changing the status of a checkout (e.g., approving a return).
  end

  # Determines if the user can delete an existing checkout
  def destroy?
    user_is_admin?
    # Only a library admin can delete a checkout.
    # Example: Removing an old or invalid checkout record.
  end

  private

  # Checks if the user is an admin of the library where the book belongs
  def user_is_admin?
    record.book.library.library_users.exists?(user_id: user.id, is_admin: true)
    # This checks if the current user is an admin of the library the book belongs to:
    # - `record`: The checkout being acted upon.
    # - `record.book.library`: The library associated with the book in the checkout.
    # - `library_users.exists?`: Verifies if the user has an admin role (`is_admin: true`) for the library.
  end

  # Scope class to control which checkouts a user can access
  class Scope < Scope
    def resolve
      scope.all
      # By default, allows access to all checkouts.
      # Modify this to restrict access based on roles or user-specific rules.
      # Example: `scope.where(user_id: user.id)` to limit results to the current user's checkouts.
    end
  end
end