Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :projects do
    resources :projects, :path => '', :only => [:index, :show, :edit, :update] do
      member do
        get :enter
        get :leave
      end
    end
  end

  devise_scope :refinery_user do
    get 'login', :to => 'sessions#new', :as => :new_refinery_user_session
    get 'logout', :to => 'sessions#destroy', :as => :destroy_refinery_user_session
    get 'profile', :to => 'users#my_profile'
    get 'profile/edit', :to => 'users#edit'
    put 'profile/edit', :to => 'users#update'
    get 'users/register', :to => 'users#new'
    get 'register', :to => 'users#new'
    get 'users/:id', :to => 'users#show', :as => :show_refinery_user
  end

  # Admin routes
  namespace :projects, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :projects, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
    namespace :admin, :path => 'refinery/projects' do
      resources :types, :except => :show
      resources :days, :except => :show
      resources :locations, :except => :show
      resources :sectors, :except => :show
      resources :volunteer_types, :except => :show
    end
  end
end
