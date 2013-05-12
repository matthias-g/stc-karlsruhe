Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :projects do
    resources :projects, :path => '', :only => [:index, :show]
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
