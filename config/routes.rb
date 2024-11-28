Rails.application.routes.draw do

  devise_for :users
  root "pages#home"

  resources :libraries do
    # Creates RESTful routes for libraries (index, show, new, create, edit, update, destroy).
    # Additional custom routes are added below for specific library-related functionality.

    # Member routes for library-specific dashboards
    member do
      get :admin_dashboard_form
      # Route: GET /libraries/:id/admin_dashboard_form
      # Displays a form for verifying admin credentials for a specific library.

      post :admin_dashboard_access
      # Route: POST /libraries/:id/admin_dashboard_access
      # Handles the logic to grant access to the admin dashboard.

      get :admin_dashboard, to: 'libraries/admin_dashboards#show'
      # Route: GET /libraries/:id/admin_dashboard
      # Displays the admin dashboard for a specific library by calling the `show` action in
      # the `Libraries::AdminDashboardsController`.

      get :user_dashboard, to: 'libraries/user_dashboards#show'
      # Route: GET /libraries/:id/user_dashboard
      # Displays a user-specific dashboard for a library using the `show` action in
      # the `Libraries::UserDashboardsController`.

      patch :approve_reservation, to: 'libraries/admin_dashboards#approve_reservation'
      # Route: PATCH /libraries/:id/approve_reservation
      # Handles logic to approve a book reservation in the library via the `approve_reservation`
      # action in `Libraries::AdminDashboardsController`.

      patch :deny_reservation, to: 'libraries/admin_dashboards#deny_reservation'
      # Route: PATCH /libraries/:id/deny_reservation
      # Handles logic to deny a book reservation in the library via the `deny_reservation`
      # action in `Libraries::AdminDashboardsController`.
    end

    # Collection routes for accessing libraries by unique ID
    collection do
      get :access_form, to: 'libraries#access_form'
      # Route: GET /libraries/access_form
      # Displays a form to input the library name and unique ID for library access.

      post :access, to: 'libraries#access'
      # Route: POST /libraries/access
      # Handles the logic to access a library based on the unique ID provided in the form.
    end

    # Nested resources for books
    resources :books, controller: 'libraries/books', only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      # Defines nested RESTful routes for books within libraries.
      # Routes are restricted to the actions specified in `only`.

      # Actions specific to books
      member do
        post :reserve
        # Route: POST /libraries/:library_id/books/:id/reserve
        # Handles the logic to reserve a specific book.

        patch :approve_reservation
        # Route: PATCH /libraries/:library_id/books/:id/approve_reservation
        # Handles the approval of a reservation for the specified book.

        get :read
        # Route: GET /libraries/:library_id/books/:id/read
        # Displays the content of an eBook or other readable content for the specified book.

        post :reserve
        # (Duplicate route: consider removing or merging with the earlier `post :reserve`.)

        post :cancel_reservation
        # Route: POST /libraries/:library_id/books/:id/cancel_reservation
        # Handles the logic to cancel a reservation for the specified book.
      end

      # Reviews nested within books
      resources :reviews, only: [:create, :destroy]
      # Creates routes for creating and destroying reviews for books.
      # Example:
      # - POST /libraries/:library_id/books/:book_id/reviews
      # - DELETE /libraries/:library_id/books/:book_id/reviews/:id
    end

    # Wishlists nested within libraries
    resources :wishlists, only: [:index, :create]
    # Creates routes for managing wishlists within libraries:
    # - GET /libraries/:library_id/wishlists (index action)
    # - POST /libraries/:library_id/wishlists (create action)
  end

  # Checkouts routes
  resources :checkouts, only: [:index, :new, :create, :edit, :update] do
    patch :return, on: :member
    # Route: PATCH /checkouts/:id/return
    # Marks a specific book as returned via the `return` action.
  end

  # Notifications routes
  resources :notifications, only: [:create]
  # Creates a route for creating notifications:
  # - POST /notifications (create action)

  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check
  # Route: GET /up
  # Used for application health checks, often to ensure that the app is running.
  # Calls the `show` action in the `Rails::HealthController`.
  # The route is named `rails_health_check` for easy reference.
end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
