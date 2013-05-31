module Refinery
  class UsersController < Devise::RegistrationsController

    # Protect these actions behind an admin login
    before_filter :redirect?, :only => [:new, :create]
    before_filter :authenticate_refinery_user!, :only => [:projects]

    helper Refinery::Core::Engine.helpers
    layout 'refinery/layouts/login'

    def new
      @user = User.new
    end

    # This method should only be used to create the first Refinery user.
    def create
      @user = User.new(params[:user])

      if refinery_users_exist?
        if @user.create_volunteer
          sign_in(@user)
          flash[:message] = "<h2>#{t('welcome', :scope => 'refinery.users.create', :who => @user.username).gsub(/\.$/, '')}.</h2>".html_safe
          # TODO gescheiter redirect
          redirect_back_or_default('/users/projects')
        else
          render :new
        end
      else
        if @user.create_first
          flash[:message] = "<h2>#{t('welcome', :scope => 'refinery.users.create', :who => @user.username).gsub(/\.$/, '')}.</h2>".html_safe

          sign_in(@user)
          redirect_back_or_default(refinery.admin_root_path)
        else
          render :new
        end
      end
    end

    def projects
      if refinery_user_signed_in?
        @projects_as_volunteer = current_refinery_user.projects_as_volunteer
        @projects_as_leader = current_refinery_user.projects_as_leader
      end
    end

    protected

    def redirect?
      if refinery_user?
        redirect_to refinery.admin_users_path
      end
    end

    def refinery_users_exist?
      Refinery::Role[:refinery].users.any?
    end

  end
end
