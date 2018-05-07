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


  BOOTSTRAP_FLASH_MSG = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
  }

  # Converts a rails flash type to a Bootstrap alert type
  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
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
    signed_in? && (current_user.roles.any? || current_user.actions_as_leader.any?)
  end

  # Replaces patterns "[Title](URL)" and "<URL>" with a clickable link
  def simple_format_urls text
    markdown_inline_style = %r{\[(.*)\]\(((?:https?|mailto)://\S+)\)}
    text = text.gsub markdown_inline_style, '<a href="\2" target="_blank">\1</a>'
    angle_brackets = %r{\<((?:https?|mailto)://\S+)\>}
    text.gsub angle_brackets, '<a href="\1" target="_blank">\1</a>'
  end

  # Replaces patterns "[Title](URL)" and "<URL>" with "Title (URL)" / just the URL
  def format_urls_no_html text
    markdown_inline_style = %r{\[(.*)\]\(((?:https?|mailto)://\S+)\)}
    text = text.gsub markdown_inline_style, '\1 (\2)'
    angle_brackets = %r{\<((?:https?|mailto)://\S+)\>}
    text.gsub angle_brackets, '\1'
  end

  # Returns the name of an ActiveRecord, which may be a User, Role, Event or Action
  def get_name_for model
    return 'nil' if model.nil?
    return model.full_name if model.is_a? User
    return model.title if model.is_a? Role
    return model.initiative.full_title if model.is_a? Event
    return model.full_title if model.is_a? Action
    'no_idea'
  end

  # Creates a ujs remote link with JSONAPI content
  def api_link(name, target, action, html_options = nil, &block)
    html_options, action, target, name = action, target, name, block if block_given?
    html_options ||= {}
    model = target[0]
    model_name = model.model_name

    # map actions to HTTP methods
    method_map = {create: :put, update: :patch, list: :get, show: :get, delete: :delete, remove: :delete, add: :post}
    method = method_map[action] || action

    # set basic UJS data attributes, URL and localization key
    data = html_options[:data] || {}
    data.merge!(remote: true, method: method, type: :jsonapi)
    url = '/api/%s/%s' % [model_name.route_key.sub('_', '-'), model.id]
    i18n_key = action.to_s

    # are we changing an association?
    if target.length > 1
      rel_model = target.last
      rel_name = (target.length == 3) ? target[1] : rel_model.model_name.collection
      url += '/relationships/' + rel_name
      i18n_key += rel_name.singularize.camelcase
      data.merge!(params: [type: rel_model.model_name.route_key, id: rel_model.id])
    end

    # are we changing an attribute?
    if (action == :update) && (html_options.key? :attributes)
      data.merge!(params: {type: model.model_name.route_key, id: model.id,
                           attributes: html_options[:attributes]})
    end

    # add success message
    unless data.key? 'success-message'
      success_message = t(model_name.singular + '.message.' + i18n_key + 'Success',
                          model: get_name_for(model), rel_model: get_name_for(rel_model))
      data.merge!('success-message': success_message)
    end

    # get link title
    title = html_options[:title] || t(model_name.singular + '.action.' + i18n_key)

    # set title as linktext
    name = title if (name == :auto_name)

    # add icon (if set, or choose icon by action)
    icon_map = {create: 'fas fa-add', update: 'fas fa-save', list: 'fas fa-list', show: 'fas fa-eye',
                delete: 'fas fa-trash', remove: 'fas fa-times', add: 'fas fa-add'}
    icon = html_options[:icon] || icon_map[action]
    name = '<span class="' + icon + '"></span>' + name unless icon.blank?

    link_to sanitize(name), url, html_options.merge(title: title, data: data).except(:icon, :attributes)
  end

  # Creates a selectpicker (for adding to a user->model or model->user relation)
  def user_select_picker(model, rel_name, is_user_rel = false, html_options = nil)
    html_options ||= {}
    html_options[:class] ||= ''

    # set handler attributes
    if is_user_rel
      handling = {
        url: '/api/%s/{id}/relationships/%s' % [User.model_name.route_key, rel_name],
        data: [type: model.model_name.plural, id: model.id]
      }
      i18n_base = User.model_name.singular
    else
      handling = {
        url: '/api/%s/%s/relationships/%s' % [model.model_name.route_key, model.id, rel_name],
        data: [type: User.model_name.plural, id: '{id}']
      }
      i18n_base = model.model_name.singular
    end

    # add selectpicker attributes
    data = html_options[:data] || {}
    data.merge!(class: 'SelectPicker', live_search: true, size: 5,
                handling: handling.merge(method: 'POST'), type: 'jsonapi')
    html_options[:class] += ' selectpicker'
    html_options[:title] = t('general.action.add') unless html_options.key? :title

    # add success message
    unless data.key? 'success-message'
      success_message = t(i18n_base + '.message.add' + rel_name.singularize.camelcase + 'Success')
      data.merge!('success-message': success_message)
    end

    id = 'add-'+ model.model_name.singular + '-' + rel_name
    select_tag id, options_for_user_select, html_options.merge(data: data)
  end

  # Creates a list of all registered users for use with a selectpicker
  def options_for_user_select
    options = policy_scope(User.all.where(cleared: false)).order(:first_name, :last_name).map do |user|
      tokens = "#{user.username} #{user.full_name}"
      [user.full_name, user.id, {data: { tokens: tokens }}]
    end
    options_for_select(options)
  end

end
