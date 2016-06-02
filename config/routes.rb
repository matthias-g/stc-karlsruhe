StcKarlsruhe::Application.routes.draw do

  resources :news_entries, path: 'news' do
    member do
      get :crop_picture
    end
  end

  scope module: 'surveys' do
    resources :templates, as: :surveys_templates, path: 'umfragen' do
      resources :submissions, as: :surveys_submissions, path: 'antworten'
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
  get 'statistiken/auslastung-:title', to: 'statistics#occupancy', as: :occupancy_in_year

  resources :project_weeks

  resources :project_days

  resources :roles

  get 'kontakt', to: 'messages#contact_mail_form', as: 'contact'
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

  devise_for :users, path: '',
             path_names: { sign_in: 'login', sign_out: 'logout',
                           sign_up: 'register', edit: 'edit_password'},
             controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  resources :users, except: [:new, :create] do
    member do
      get :confirm_delete
      post :contact_user
    end
  end
  get :login_or_register, to: 'users#login_or_register'

  root 'pages#home'
  get '/eigenes-projekt', to: 'pages#own_project', as: :own_project
  get '/:page', to: 'pages#page', as: :show_page

  namespace :api, constraints: { format: 'json' } do
    resources :galleries, only: :show
    resources :gallery_pictures, only: [:destroy] do
      member do
        get :rotateRight
        get :rotateLeft
      end
    end
    resources :projects, only: :show do
      member do
        get :enter
        get :leave
        get :add_leader
      end
    end
    resources :project_weeks, only: [:index] do
      member do
        get :projects
        get :project_days
      end
    end
    scope module: 'surveys' do
      resources :templates, as: :surveys_templates, path: 'umfragen' do
        resources :submissions, as: :surveys_submissions, path: 'antworten'
      end
    end
  end

end
