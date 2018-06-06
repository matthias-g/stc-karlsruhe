
module ApiHelper

  # Creates a ujs remote link with JSONAPI content
  def api_link(name, target, action, html_options = nil, &block)
    html_options, action, target, name = action, target, name, block if block_given?
    html_options ||= {}

    model = target[0]
    i18n_base = model.model_name.singular

    # map actions to HTTP methods
    method_map = {create: :put, update: :patch, list: :get, show: :get, delete: :delete, remove: :delete, add: :post}
    method = method_map[action] || action

    # set basic UJS data attributes, URL and localization key
    data = html_options[:data] || {}
    data.merge!(remote: true, method: method, type: :jsonapi)
    url = '/api/%s/%s' % [model.model_name.route_key.sub('_', '-'), model.id]
    i18n_key = action.to_s

    # are we changing an association?
    if target.length > 1
      rel_model = target.last
      rel_name = (target.length == 3) ? target[1].to_s : rel_model.model_name.collection
      url += '/relationships/' + rel_name
      i18n_key += rel_name.singularize.camelcase
      data.merge!(params: [type: rel_model.model_name.route_key, id: rel_model.id])
    end

    # are we changing an attribute?
    if (action == :update) && (html_options.key? :attributes)
      data.merge!(params: {type: model.model_name.route_key, id: model.id,
                           attributes: html_options[:attributes]})
    end

    # get success message
    unless data.key? 'success-message'
      success_message = t(i18n_base + '.message.' + i18n_key + 'Success',
                          model: get_name_for(model), rel_model: get_name_for(rel_model))
      data.merge!('success-message': success_message)
    end

    # get link title
    title = html_options[:title] || t(i18n_base + '.button.' + i18n_key)

    # get linktext from title
    name = title if (name == :auto_name)

    # add icon
    name = render_icon(html_options[:icon] || action) + name

    html_options = html_options.merge(title: title, data: data).except(:icon, :attributes)
    link_to sanitize(name), url, html_options
  end


  # Creates a selectpicker (for adding to a user->model or model->user relation)
  def user_select_picker(model, rel_name, is_user_rel = false, html_options = nil)
    html_options ||= {}
    html_options[:class] ||= ''
    rel_name = rel_name.to_s

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
    html_options[:title] = t('general.button.add') unless html_options.key? :title

    # add success message
    unless data.key? 'success-message'
      success_message = t(i18n_base + '.message.add' + rel_name.singularize.camelcase + 'Success', model: get_name_for(model))
      data.merge!('success-message': success_message)
    end

    id = 'add-'+ model.model_name.singular + '-' + rel_name
    select_tag id, options_for_user_select, html_options.merge(data: data)
  end


  # PRIVATE

  # Renders an icon. Accepts either a typical action symbol, or a string of fontawesome classes
  def render_icon(icon)
    icon_map = {create: 'fas fa-add', update: 'fas fa-save', list: 'fas fa-list', show: 'fas fa-eye',
                delete: 'fas fa-trash', remove: 'fas fa-times', add: 'fas fa-add'}
    icon = icon.is_a?(String) ? icon : icon_map[icon]
    '<span class="' + icon + '"></span>'
  end

  # Returns the name of an ActiveRecord, which may be a User, Role, Event or Initiative
  def get_name_for(model)
    if model.nil?
      'nil'
    elsif model.is_a? User
      model.full_name
    elsif model.is_a? Role
      model.title
    elsif model.is_a? Event
      model.initiative.full_title
    elsif model.is_a? Initiative
      model.full_title
    else
      'unknown'
    end
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