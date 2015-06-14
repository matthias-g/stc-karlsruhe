StcKarlsruhe::Application.routes.draw do

  scope module: 'feedback' do
    resources :surveys, as: :feedback_surveys do
      resources :survey_answers, as: :feedback_survey_answers
    end
  end

  resources :gallery_pictures do
    member do
      get :make_visible
      get :make_invisible
    end
  end

  resources :galleries do
    member do
      get :make_all_visible
      get :make_all_invisible
    end
  end

  get 'statistiken/teilnahmen', to: 'statistics#participations'
  get 'statistiken/teilnahmen/:date', to: 'statistics#participations_on_day', as: :participations_on_day
  get 'statistiken/auslastung', to: 'statistics#occupancy'

  resources :project_weeks

  resources :project_days

  resources :roles

  get 'kontakt', to: 'messages#contact_form', as: 'contact'
  post 'kontakt', to: 'messages#send_contact_mail'

  get 'admin_mail', to: 'messages#admin_mail_form'
  post 'admin_mail', to: 'messages#send_admin_mail'

  resources :projects, path: 'projekte' do
    member do
      get :enter
      get :leave
      get :edit_leaders
      post :add_leader
      delete :delete_leader
      delete :delete_volunteer
      get :make_visible
      get :make_invisible
      get :open
      get :close
      get :crop_picture
      post :contact_volunteers
    end
  end
  get 'projekte-:year', to: 'projects#index'
  get 'projektwoche-:title', to: 'project_weeks#show', as: 'show_project_week'

  devise_for :users,
    path: '', path_names: { sign_in: 'login', sign_out: 'logout',
                            sign_up: 'register', edit: 'edit_password'}

  resources :users, except: [:new, :create] do
    member do
      get :confirm_delete
      post :contact_user
    end
  end
  get :login_or_register, to: 'users#login_or_register'

  root 'pages#home'
  get '/:page', to: 'pages#page', as: :show_page

  namespace :api do
    resources :projects, only: :show
    resources :project_weeks, only: [:index] do
      member do
        get :projects
        get :project_days
      end
    end
    resources :galleries, only: :show
    resources :gallery_pictures, only: :destroy
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#contact'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
