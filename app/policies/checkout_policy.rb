class CheckoutPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  
  def index?
    user.admin? || checkout.user_id == user.id # user can view list of their reservations
  end

  # def show?
  #   user.admin? || checkout.user_id == user.id # user can view a details view of the reservation
  # end

  def create?
    user.admin? || checkout.user_id == user.id # user can create a reservation
  end

  # def update?
  #   user.admin? || checkout.user_id == user.id 
  # end

  def destroy?
    user.admin? || checkout.user_id == user.id # user can delete the reservation
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
