class ReviewPolicy < ApplicationPolicy
  def create?
    library_member?
  end

  def destroy?
    library_admin? || user == record.user
  end

  private

  def library_member?
    user.libraries.exists?(id: record.book.library_id)
  end

  def library_admin?
    LibraryUser.exists?(library_id: record.book.library_id, user_id: user.id, is_admin: true)
  end
end
