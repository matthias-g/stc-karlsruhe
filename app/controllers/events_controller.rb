class EventsController < ApplicationController
  before_action :set_event
  before_action :authenticate_user!, except: [:register_for_participation]
  before_action :authorize_event, except: [:register_for_participation]

  after_action :verify_authorized, except: [:index, :register_for_participation]
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def enter
    @event.add_volunteer(current_user)
    redirect_to action_url(@event.initiative), notice: t('action.message.enteredAction')
  end

  def leave
    @event.delete_volunteer(current_user)
    redirect_to action_url(@event.initiative), notice: t('action.message.leftAction')
  end

  def register_for_participation
    store_location_for(:user, enter_event_path(@event))
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event
    authorize @event
  end

end