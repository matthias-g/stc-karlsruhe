# noinspection ALL
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

  # Converts a rails flash type to a Bootstrap alert type
  def bootstrap_alert_class(flash_type)
    alert_map = {
        success: 'alert-success',
        error: 'alert-danger',
        alert: 'alert-warning',
        notice: 'alert-info'
    }
    alert_map.fetch(flash_type.to_sym, flash_type.to_s)
  end

  # Adds all errors for the given resources to the flash messages
  def show_errors_for(resource)
    return if resource.errors.empty?
    resource.errors.full_messages.each do |msg|
      flash.now[:error] = msg
    end
  end

  # Replaces wrapper classes with the given classes
  def wrapper_set(*new_classes)
    wrapper_classes.clear.merge(new_classes)
  end

  # Returns the current wrapper classes as an alterable set.
  def wrapper_classes
    (@wrapper_classes ||= Set['white-box', 'container-medium'])
  end

  # Returns whether the user has any roles or leaderships
  def privileged_user?
    signed_in? && (current_user.roles.any? || current_user.initiatives_as_leader.any?)
  end

  # Replaces patterns "[Title](URL)" and "<URL>" with a clickable link
  def simple_format_urls text
    markdown_inline_style = %r{\[(.*)\]\(((?:https?://|mailto:)\S+)\)}
    text = text.gsub markdown_inline_style, '<a href="\2" target="_blank">\1</a>'
    angle_brackets = %r{\<((?:https?://|mailto:)\S+)\>}
    text.gsub angle_brackets, '<a href="\1" target="_blank">\1</a>'
  end

  # Replaces patterns "[Title](URL)" and "<URL>" with "Title (URL)" / just the URL
  def format_urls_no_html text
    markdown_inline_style = %r{\[(.*)\]\(((?:https?://|mailto:)\S+)\)}
    text = text.gsub markdown_inline_style, '\1 (\2)'
    angle_brackets = %r{\<((?:https?://|mailto:)\S+)\>}
    text.gsub angle_brackets, '\1'
  end

end
