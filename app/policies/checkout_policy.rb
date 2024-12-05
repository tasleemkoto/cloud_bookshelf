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

  def approve_reservation?
    library_admin?
  end

  def deny_reservation?
    library_admin?
  end


  private

  def library_admin?
    record.book.library.library_users.exists?(user_id: user.id, is_admin: true)
  end
end
