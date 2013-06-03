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
    get 'profile', :to => 'users#my_profile'
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
