module OrgaMessagesHelper

  # Returns allowed options for orga message senders
  def from_options
    ['Serve the City Karlsruhe <contact@servethecity-karlsruhe.de>',
     'Serve the City Karlsruhe <orga@servethecity-karlsruhe.de>',
     'Serve the City Karlsruhe <no-reply@servethecity-karlsruhe.de>',
     current_user.full_name + ' <' + current_user.email + '>']
        .map{|g| [g, g]}
  end

  # Returns the translation for an orga mail recipient group
  def render_recipient_group_abstract recipient_group
    I18n.t('orga_message.form.recipients.' + recipient_group)
  end

  # Returns the translation for an orga mail recipient group
  def render_recipient_group message
    sender = message.sender.present? ? message.sender : current_user
    I18n.t('orga_message.form.groups.' + message.recipient, user_email: sender.email, action_group: message.action_group.title)
  end

  # Returns allowed options for orga mail recipients
  def recipient_options
    %w(current_volunteers_and_leaders current_volunteers current_leaders newsletter sender)
        .map{|group| [render_recipient_group_abstract(group), group]}
  end

  # Returns allowed options for orga mail topics
  def content_type_options
    %w(about_action_groups about_other_projects other_email_from_orga)
        .map{|type| [t('orga_message.form.content_types.' + type), type]}
  end

  def mail_type_to_subscription(type)
    mapping = {
        about_action_groups: 'receive_emails_about_action_groups',
        about_other_projects: 'receive_emails_about_other_projects',
        other_email_from_orga: 'receive_other_emails_form_orga'
    }
    mapping[type.to_sym]
  end

end
