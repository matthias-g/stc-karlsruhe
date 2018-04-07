class EventsController < ApplicationController
  before_action :set_event
  before_action :authenticate_user!
  before_action :authorize_event

  after_action :verify_authorized, except: :index
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

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event
    authorize @event
  end

end