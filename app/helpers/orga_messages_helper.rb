module OrgaMessagesHelper
  def from_options
    ['Serve the City Karlsruhe <contact@servethecity-karlsruhe.de>',
     'Serve the City Karlsruhe <orga@servethecity-karlsruhe.de>',
     'Serve the City Karlsruhe <no-reply@servethecity-karlsruhe.de>',
     current_user.full_name+ ' <' + current_user.email + '>']
        .map{|g| [g, g]}
  end

  def render_recipient_group group, user
    I18n.t('contact.adminMail.groups.' + group, user_email: user.email, project_week: ProjectWeek.default.title)
  end

  def recipient_options
    %w(current_volunteers_and_leaders current_volunteers current_leaders all_users active_users me)
        .map{|group| [render_recipient_group(group, current_user), group]}
  end

  def content_type_options
    %w(about_project_weeks about_other_projects other_email_from_orga)
        .map{|type| [t('contact.adminMail.types.' + type), type]}
  end

end