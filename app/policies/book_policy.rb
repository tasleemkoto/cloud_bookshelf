class BookPolicy < ApplicationPolicy
# The `BookPolicy` inherits from `ApplicationPolicy`, which provides common methods
# and serves as a base class for all policies.

# Inner class `Scope` to control which books a user can access
class Scope < Scope
  # Defines the scope of books the user is allowed to view
  def resolve
    scope.joins(:library).where(library: user.libraries)
    # The `resolve` method filters books to only those belonging to libraries
    # the user is a member of. It joins the `books` table with the `libraries` table
    # and checks that the library is in the user's associated libraries.
  end
end

# Permissions for viewing books

def index?
  library_member? # All members of a library can view books in that library.
end

def show?
  library_member? # Members of a library can view individual books in that library.
end

# Permissions for reserving books

def reserve?
  user.present? && record.format == "hardcover" && record.quantity.to_i.positive?
  # A book can be reserved if:
  # - The user is logged in (`user.present?`).
  # - The book format is "hardcover".
  # - There is at least one copy available (`quantity.to_i.positive?`).
end

def approve_reservation?
  library_admin? # Only library admins can approve reservations for books.
end

# Permissions for CRUD operations

def create?
  library_admin? # Only admins can create books in the library.
end

def update?
  library_admin? # Only admins can update book information in the library.
end

def destroy?
  library_admin? # Only admins can delete books from the library.
end

def deny_reservation?
  library_admin? # Only admins can deny reservations for books.
end

def cancel_reservation?
  user.checkouts.pending.exists?(book: record)
  # A user can cancel their reservation if they have a pending checkout
  # for the specific book (`record`) they want to cancel.
end

private

# Check if the user is an admin of the book's library
def library_admin?
  if record.is_a?(ActiveRecord::Relation) || record.is_a?(Array)
    # If the record is a collection of books (e.g., `ActiveRecord::Relation` or `Array`),
    # check if the user is an admin for the library of the first book in the collection.
    user.library_users.exists?(library: record.first.library, is_admin: true)
  else
    # If the record is a single book, check if the user is an admin for that book's library.
    user.library_users.exists?(library: record.library, is_admin: true)
  end
end

# Check if the user is a member of the book's library
def library_member?
  if record.is_a?(ActiveRecord::Relation) || record.is_a?(Array)
    # If the record is a collection of books, check if the user is a member of
    # the library for the first book in the collection.
    user.libraries.exists?(id: record.first.library_id)
  else
    # If the record is a single book, check if the user is a member of that specific library.
    user.libraries.exists?(id: record.library_id)
  end
end
end