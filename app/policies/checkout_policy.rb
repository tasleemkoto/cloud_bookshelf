class CheckoutPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(book: :library).where(library: user.libraries)
    end
  end

  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    library_admin?
  end

  def destroy?
    library_admin?
  end

  def return?
    library_admin? || record.user == user
  end

  def approve?
    user.library_admin?(record.library) # Only library admins can approve reservations
  end

  def deny?
    user.library_admin?(record.library) # Only library admins can deny reservations
  end


  private

  def library_admin?
    library_user = LibraryUser.find_by(user_id: id, library_id: library.id)
    library_user&.is_admin || false
  end
end
