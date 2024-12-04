class LibraryUserPolicy < ApplicationPolicy
  def index?
    library_admin?
  end

  def create?
    library_admin?
  end

  def update?
    library_admin?
  end

  def destroy?
    library_admin?
  end

  private

  def library_admin?
    record.library.library_users.exists?(user: user, is_admin: true)
  end
end
