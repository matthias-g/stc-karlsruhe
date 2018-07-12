
module ApiHelper

  def vue_component(component_name, options = {})
    html_options = options.each_with_object({}) do |(key, value), object|
      new_key = key.to_s.dasherize
      if value.is_a? String
        object[new_key] = value
      else
        object['v-bind:' + new_key] = value.to_json
      end
    end
    content_tag(component_name.underscore.dasherize, '', html_options)
  end

  def include_requests(requests)
    mapped = requests.map do |request, response|
      "window.included_requests[\"#{request}\"] = #{response};"
    end
    raw("<script>window.included_requests = window.included_requests || {}; #{mapped.join(',')};</script>")
  end

  # SelectPicker for adding to an association
  def api_add_select(model, association, klass, options, html_options = nil)
    html_options ||= {}
    name, url, i18n_key = get_api_relationship_info(model, association, :add)
    new_options = {
        title: t(i18n_key % 'button'),
        data: {
            class: 'SelectPicker', live_search: true, size: 5, type: :jsonapi,
            handling: {method: 'POST', url: url, data: [type: klass.model_name.plural, id: '{id}']},
            'success-message': t((i18n_key % 'message') + 'Success', model: get_name_for(model))
        }
    }
    select_tag name, options, html_options.deep_merge(new_options)
  end

  # Link for removing object from an association
  def api_remove_link(name, model, association, object, confirm, html_options = nil, &block)
    name, model, association, object, html_options = block, name, model, association, object if block_given?
    html_options ||= {}
    id, url, i18n_key = get_api_relationship_info(model, association, :remove)
    new_options = {
        title: t(i18n_key % 'button'),
        data: {
            remote: true, method: :delete, type: :jsonapi,
            params: [type: object.model_name.route_key, id: object.id],
            'success-message': t((i18n_key % 'message') + 'Success',
                                 model: get_name_for(model), association: get_name_for(object))
        }
    }
    new_options[:data][:confirm] = t('general.message.confirmRemoveLong', subject: get_name_for(object)) if confirm
    render_button(name, :remove, i18n_key, url, html_options.deep_merge(new_options))
  end

  # Button for altering attributes of a model
  def api_update_link(action, model, attributes, html_options = nil, &block)
    i18n_key = "#{model.model_name.singular}.%s.#{action.to_s.camelize(:lower)}"
    url = "/api/#{model.model_name.route_key.sub('_', '-')}/#{model.id}"
    new_options = {
        title: t(i18n_key % 'button'),
        data: {
            remote: true, method: :patch, type: :jsonapi,
            params: {type: model.model_name.route_key, id: model.id, attributes: attributes},
            'success-message': t((i18n_key % 'message') + 'Success', model: get_name_for(model))
        }
    }
    render_button(block_given? ? block : t(i18n_key % 'button'), action,
                  i18n_key, url, html_options.deep_merge(new_options))
  end



  private

  def get_api_relationship_info(model, association, method)
    name = "#{method}-#{model.model_name.singular}-#{association.to_s.singularize}"
    url = "/api/#{model.model_name.route_key.sub('_', '-')}/#{model.id}/relationships/#{association}"
    i18n_key = "#{model.model_name.singular}.%s.#{method}#{association.to_s.singularize.camelize}"
    return name, url, i18n_key
  end

  def render_button(name, icon, i18n_key, url, html_options)
    # get link title
    title = html_options[:title] || t(i18n_key % 'button')
    # get linktext from title
    name = title if (name == :auto_name)
    # add icon
    name = render_icon(icon) + name unless icon.nil?
    link_to(sanitize(name), url, html_options.merge(title: title))
  end

  # Renders an icon. Accepts either a typical action symbol, or a string of fontawesome classes
  def render_icon(icon)
    icon_map = {create: 'fas fa-add', update: 'fas fa-save', list: 'fas fa-list', show: 'fas fa-eye',
                hide: 'fas fa-eye-slash', delete: 'fas fa-trash', remove: 'fas fa-times', add: 'fas fa-add'}
    icon = icon.is_a?(String) ? icon : icon_map[icon]
    icon.nil? ? '' : '<span class="' + icon + '"></span>'
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
    query = policy_scope(User.all.where(cleared: false)).order(:first_name, :last_name)
    options = query.map{|user| [user.full_name, user.id, {
        data: { tokens: "#{user.username} #{user.full_name}" }}]}
    options_for_select(options)
  end

  def options_for_tag_select
    query = policy_scope(Tag.all).order(:title)
    options = query.map{|c| [c.title, c.id,
        data: {tokens: "#{c.title} #{c.id}"}]}
    options_for_select(options)
  end

end