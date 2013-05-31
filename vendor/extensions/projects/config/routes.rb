Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :projects do
    resources :projects, :path => '', :only => [:index, :show] do
      member do
        get :enter
        get :leave
      end
    end
  end

  devise_scope :refinery_user do
    get 'users/projects', :to => 'users#projects'
    get 'users/register', :to => 'users#new'
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
  end

end
