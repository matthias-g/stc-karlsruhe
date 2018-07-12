JSONAPI.configure do |config|
  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]

  # Resource Linkage
  # Controls the serialization of resource linkage for non compound documents
  # NOTE: always_include_to_many_linkage_data is not currently implemented
  config.always_include_to_one_linkage_data = true

  #config.resource_cache = Rails.cache
end

JSONAPI::Authorization.configure do |config|
  config.authorizer = JSONAPI::Authorization::CustomAuthorizer
end

module JSONAPI
  module Authorization
    AuthorizingProcessor.class_eval do

      def authorize_replace_to_one_relationship
        return authorize_remove_to_one_relationship if params[:key_value].nil?

        source_resource = @resource_klass.find_by_key(
            params[:resource_id],
            context: context
        )
        source_record = source_resource._model

        relationship_type = params[:relationship_type].to_sym
        new_related_resource = @resource_klass
                                   ._relationship(relationship_type)
                                   .resource_klass
                                   .find_by_key(
                                       params[:key_value],
                                       context: context
                                   )
        new_related_record = new_related_resource._model unless new_related_resource.nil?

        authorizer.replace_to_one_relationship(
            source_record,
            new_related_record,
            relationship_type
        )
      end

      def authorize_create_to_many_relationship
        source_record = @resource_klass.find_by_key(
            params[:resource_id],
            context: context
        )._model

        relationship_type = params[:relationship_type].to_sym
        related_models =
            model_class_for_relationship(relationship_type).find(params[:data])

        authorizer.create_to_many_relationship(source_record, related_models, relationship_type)
      end

      def authorize_replace_to_many_relationship
        source_resource = @resource_klass.find_by_key(
            params[:resource_id],
            context: context
        )
        source_record = source_resource._model

        relationship_type = params[:relationship_type].to_sym
        new_related_records = model_class_for_relationship(relationship_type).find(params[:data])

        authorizer.replace_to_many_relationship(
            source_record,
            new_related_records,
            relationship_type
        )
      end

      def authorize_remove_to_many_relationship
        source_resource = @resource_klass.find_by_key(
            params[:resource_id],
            context: context
        )
        source_record = source_resource._model

        relationship_type = params[:relationship_type].to_sym
        related_resource = @resource_klass
                               ._relationship(relationship_type)
                               .resource_klass
                               .find_by_key(
                                   params[:associated_key],
                                   context: context
                               )
        related_record = related_resource._model unless related_resource.nil?

        authorizer.remove_to_many_relationship(
            source_record,
            related_record,
            relationship_type
        )
      end

      def authorize_remove_to_one_relationship
        source_record = @resource_klass.find_by_key(
            params[:resource_id],
            context: context
        )._model

        relationship_type = params[:relationship_type].to_sym

        authorizer.remove_to_one_relationship(source_record, relationship_type)
      end

    end
  end
end