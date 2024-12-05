class LibraryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:library_users).where(library_users: { user_id: user.id })
    end
  end

  def show?
    Rails.logger.debug "User: #{user.inspect}, Library: #{record.inspect}"
    library_member? || library_admin?
  end

  def create?
    user.present?
  end

  def update?
    library_admin?
  end

  def access_form?
    true # Allow all users to see the access form
  end

  def access?
    user.present? # Example: allow logged-in users to access libraries
  end

  def destroy?
    library_admin?
  end

  def admin_dashboard?
    library_admin?
  end

  def user_dashboard?
    library_member?
  end

  private

  def library_admin?
    record.library_users.exists?(user: user, is_admin: true)
  end

  def library_member?
    record.library_users.exists?(user: user)
  end

end
