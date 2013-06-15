module Refinery
  class UsersController < Devise::RegistrationsController

    # Protect these actions behind an admin login
    before_filter :redirect?, :only => [:new, :create]
    before_filter :redirect_to_login?, :only => [:my_profile, :edit, :update]

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
          redirect_back_or_default('/profile')
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

    def my_profile
      @projects_as_volunteer = current_refinery_user.projects_as_volunteer
      @projects_as_leader = current_refinery_user.projects_as_leader
    end

    def edit
      @user = current_refinery_user
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      if current_refinery_user.update_attributes(params[:user])
        set_flash_message :notice, :updated
        sign_in current_refinery_user, :bypass => true
        redirect_to after_update_path_for(current_refinery_user)
      else
        @user = current_refinery_user
        render(:action => :edit)
      end
    end

    protected

    def redirect?
      if refinery_user?
        redirect_to refinery.admin_users_path
        false
      end
    end

    def redirect_to_login?
      if !refinery_user_signed_in?
        redirect_to '/refinery/login'
        false
      end
    end

    def refinery_users_exist?
      Refinery::Role[:refinery].users.any?
    end

  end
end
