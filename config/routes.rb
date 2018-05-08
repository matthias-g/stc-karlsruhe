Rails.application.routes.draw do

  # action groups
  resources :action_groups, path: 'aktionsgruppen'
  get ':id/aktionen', to: 'action_groups#show', as: 'show_action_group'


  # actions & events
  resources :actions, path: 'aktionen' do
    member do
      delete :delete_leader
      get :make_visible
      get :make_invisible
      get :crop_picture
      post :contact_volunteers
      post :contact_leaders
      get :clone
    end
  end
  resources :events do
    member do
      get :enter
      get :leave
      get :register_for_participation
      delete :delete_volunteer
    end
  end


  # news entries
  resources :news_entries, path: 'news' do
    member do
      get :crop_picture
    end
  end


  # galleries
  resources :galleries do
    member do
      get :make_all_visible
      get :make_all_invisible
    end
  end
  resources :gallery_pictures do
    member do
      get :make_visible
      get :make_invisible
    end
  end


  # users & user roles
  devise_for :users, path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'edit_password'},
             controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  resources :roles, except: [:show]
  resources :users, except: [:new, :create] do
    member do
      get :confirm_delete
      post :contact_user
    end
  end


  # surveys
  scope module: 'surveys' do
    resources :templates, as: :surveys_templates, path: 'umfragen' do
      resources :submissions, as: :surveys_submissions, path: 'antworten'
    end
  end


  # messages
  post 'kontakt', to: 'messages#send_contact_mail', as: 'send_contact_mail'
  resources :orga_messages, path: 'orga-mails' do
    member do
      get :send_message
    end
  end


  # statistics
  get 'statistiken/teilnahmen', to: 'statistics#participations'
  get 'statistiken/teilnahmen/:date', to: 'statistics#participations_on_day', as: :participations_on_day
  get 'statistiken/auslastung', to: 'statistics#occupancy'
  get 'statistiken/auslastung-:title', to: 'statistics#occupancy', as: :occupancy_in_year


  # pages
  root 'pages#home'
  get '/kontakt', to: 'pages#contact', as: :contact
  get '/eigene-aktion', to: 'pages#own_action', as: :own_action
  get '/:page', to: 'pages#page', as: :show_page


  # iCal
  get 'ical/aktionen/:action_id.ics', to: 'ical#actions', as: :action_ical
  get 'ical/aktionswochen/:action_group_id.ics', to: 'ical#action_groups', as: :action_group_ical
  get 'ical/users/:ical_token/:user_id.ics', to: 'ical#users', as: :user_ical
  get 'ical/aktionen.ics', to: 'ical#all_actions', as: :all_actions_ical


  # API
  namespace :api, constraints: { format: 'json' } do
    jsonapi_resources :action_groups
    jsonapi_resources :actions
    jsonapi_resources :events
    jsonapi_resources :news_entries
    jsonapi_resources :users
    jsonapi_resources :galleries

    jsonapi_resources :gallery_pictures do
      member do
        get :rotateRight
        get :rotateLeft
      end
    end

    scope module: 'surveys' do
      resources :templates, as: :surveys_templates, path: 'umfragen' do
        resources :submissions, as: :surveys_submissions, path: 'antworten'
      end
    end

  end

end
