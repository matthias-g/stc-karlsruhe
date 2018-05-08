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
  def render_recipient_group group, user
    I18n.t('orga_message.form.groups.' + group, user_email: user.email, action_group: ActionGroup.default.title)
  end

  # Returns allowed options for orga mail recipients
  def recipient_options
    %w(current_volunteers_and_leaders current_volunteers current_leaders all_users active_users me)
        .map{|group| [render_recipient_group(group, current_user), group]}
  end

  # Returns allowed options for orga mail topics
  def content_type_options
    %w(about_action_groups about_other_projects other_email_from_orga)
        .map{|type| [t('orga_message.form.types.' + type), type]}
  end

end
