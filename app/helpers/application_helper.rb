module ApplicationHelper
  # the following 3 helpers are needed to make devise forms usable in any view
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  BOOTSTRAP_FLASH_MSG = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end

  def privileged_user?
    signed_in? && (current_user.roles.any? || current_user.projects_as_leader.any?)
  end

  def simple_format_urls text
    markdown_inline_style = %r{\[(.*)\]\(((?:https?|mailto)://\S+)\)}
    text = text.gsub markdown_inline_style, '<a href="\2" target="_blank">\1</a>'
    angle_brackets = %r{\<((?:https?|mailto)://\S+)\>}
    text.gsub angle_brackets, '<a href="\1" target="_blank">\1</a>'
  end

  def format_urls_no_html text
    markdown_inline_style = %r{\[(.*)\]\(((?:https?|mailto)://\S+)\)}
    text = text.gsub markdown_inline_style, '\1 (\2)'
    angle_brackets = %r{\<((?:https?|mailto)://\S+)\>}
    text.gsub angle_brackets, '\1'
  end
end
