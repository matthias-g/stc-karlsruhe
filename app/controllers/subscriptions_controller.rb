class SubscriptionsController < ApplicationController

  def unsubscribe
    subscription = SignedGlobalID.find(params[:sgid], for: :unsubscribe)
    return redirect_to root_path unless subscription
    type = params[:type]&.to_sym
    allowed_types = [:receive_emails_about_action_groups,
                     :receive_emails_about_other_projects,
                     :receive_other_emails_from_orga]
    success = false
    if type == :all_emails
      success = subscription.destroy
    elsif allowed_types.include? type
      success = subscription.update_attribute type, false
      unless subscription.receive_emails_about_action_groups || subscription.receive_emails_about_other_projects || subscription.receive_other_emails_from_orga
        success &&= subscription.destroy
      end
    end
    if success
      flash[:notice] = t('subscription.removal.success')
    else
      flash[:error] = t('subscription.removal.failed')
    end
    redirect_to root_path
  end

  def confirm
    subscription = SignedGlobalID.find(params[:sgid], for: :confirm)
    return redirect_to root_path unless subscription
    subscription.confirmed_at = DateTime.now
    success = subscription.save
    if success
      flash[:notice] = t('subscription.confirmation.success')
    else
      flash[:error] = t('subscription.confirmation.failed')
    end
    redirect_to root_path
  end

end
