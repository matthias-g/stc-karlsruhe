module UsersHelper

  # Infers the value of the "Receive orga mails" checkbox in the user profile edit page TODO this is outdated since subscriptions
  def receive_email_from_orga user
    user.receive_emails_about_action_groups || user.receive_emails_about_my_action_groups ||
        user.receive_emails_about_other_projects || user.receive_other_emails_from_orga
  end

  # Summarizes orga mail settings for the user profile page
  def email_reception_description user
    if receive_email_from_orga(user) && user.receive_emails_from_other_users
      t('user.info.emailReception.orgaAndUser')
    elsif receive_email_from_orga user
      t('user.info.emailReception.orga')
    elsif user.receive_emails_from_other_users
      t('user.info.emailReception.user')
    else
      t('user.info.emailReception.none')
    end
  end
  
end
