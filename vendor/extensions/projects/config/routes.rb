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
