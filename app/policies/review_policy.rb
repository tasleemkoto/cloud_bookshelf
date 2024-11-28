class ReviewPolicy < ApplicationPolicy
  # Allows all users to view the list of reviews
  def index?
    true
    # Anyone (logged in or not) can view the list of reviews.
    # If you want to restrict this to logged-in users, use `user.present?` instead.
  end

  # Allows all users to view a specific review
  def show?
    true
    # Anyone can view a single review.
    # If reviews are tied to restricted content (e.g., paid membership), you might change this to `user.present?`.
  end

  # Determines if a user can create a review
  def create?
    user.present?
    # Only logged-in users (`user.present?`) can create a review.
    # Guests (unauthenticated users) are not allowed.
  end

  # Determines if a user can update a review
  def update?
    record.user == user || user_is_admin?
    # A review can be updated if:
    # - The `record.user` (review's author) matches the `user` (current user).
    # OR
    # - The current user is an admin of the library associated with the book being reviewed.
    # Calls the `user_is_admin?` method to check admin privileges.
  end

  # Determines if a user can delete a review
  def destroy?
    record.user == user || user_is_admin?
    # A review can be deleted if:
    # - The `record.user` (review's author) matches the `user` (current user).
    # OR
    # - The current user is an admin of the library associated with the book being reviewed.
    # Uses the same logic as `update?`.
  end

  private

  # Checks if the current user is an admin of the library where the review's book belongs
  def user_is_admin?
    record.book.library.library_users.exists?(user_id: user.id, is_admin: true)
    # `record`: The Review instance being acted upon.
    # `record.book.library`: The library associated with the book being reviewed.
    # `library_users.exists?`: Checks if there is a `LibraryUser` record where:
    # - The `user_id` matches the current user's ID.
    # - The `is_admin` field is `true`.
    # Returns `true` if the user is an admin of the library.
  end

  # Scope to determine which reviews the user can see
  class Scope < Scope
    def resolve
      scope.all
      # By default, returns all reviews.
      # If you want to restrict this to reviews for books in the user's libraries, modify it:
      # Example:
      # `scope.joins(book: :library).where(library: user.libraries)`
    end
  end
end