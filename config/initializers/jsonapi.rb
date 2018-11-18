JSONAPI.configure do |config|
  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]

  # Resource Linkage
  # Controls the serialization of resource linkage for non compound documents
  # NOTE: always_include_to_many_linkage_data is not currently implemented
  config.always_include_to_one_linkage_data = true

  #config.resource_cache = Rails.cache
end
