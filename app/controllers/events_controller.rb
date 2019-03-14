class EventsController < ApplicationController
  before_action :set_event
  before_action :authenticate_user!, except: [:register_for_participation]
  before_action :authorize_event, except: [:register_for_participation]

  after_action :verify_authorized, except: [:index, :register_for_participation]
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def enter
    @event.add_volunteer(current_user)
    redirect_to @event.initiative, notice: t('action.message.entered_action')
  end

  def leave
    @event.delete_volunteer(current_user)
    redirect_to @event.initiative, notice: t('action.message.left_action')
  end

  def register_for_participation
    store_location_for(:user, enter_event_path(@event))
  end

  def delete_volunteer
    volunteer = User.find(params[:user_id])
    authorize_delete_volunteer(volunteer)
    @event.delete_volunteer(volunteer)
    redirect_to @event.initiative, notice: t('event.message.volunteer_removed')
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event
    authorize @event
  end

  def authorize_delete_volunteer(volunteer)
    unless policy(@event).allow_remove_volunteer_from_event?(volunteer, @event)
      raise Pundit::NotAuthorizedError, "not allowed to delete #{volunteer.full_name} from #{@event.initiative.title}"
    end
    skip_authorization
  end

end