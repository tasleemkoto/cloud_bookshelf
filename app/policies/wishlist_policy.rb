class WishlistPolicy < ApplicationPolicy
  # Determines if a user can view their wishlist
  def index?
    library_member?
    # Allows access to the wishlist only if the user is a member of the library
    # associated with the wishlist.
  end

  # Determines if a user can add books to their wishlist
  def create?
    library_member?
    # Allows a user to add books to their wishlist only if they are a member of
    # the library where the book is located.
  end

  private

  # Helper method to check if the user is a member of the wishlist's library
  def library_member?
    user.libraries.include?(record.library)
    # Checks if the `record.library` (the library associated with the wishlist)
    # is included in the list of libraries the user belongs to.
    # - `user.libraries`: The libraries the user is a member of.
    # - `record.library`: The library associated with the wishlist.
    # Returns `true` if the user is a member of the library.
  end
end