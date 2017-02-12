module JSONAPI
  module Authorization
    class CustomAuthorizer < JSONAPI::Authorization::DefaultPunditAuthorizer

      def replace_to_one_relationship(source_record, new_related_record, relationship_type)
        policy = ::Pundit.policy(user, source_record)
        relationship_method = "replace_#{relationship_type}?"
        allowed = if policy.respond_to?(relationship_method)
                    policy.send(relationship_method, new_related_record)
                  else
                    policy.update?
                  end
        raise ::Pundit::NotAuthorizedError unless allowed
      end

      def create_to_many_relationship(source_record, new_related_records, relationship_type)
        policy = ::Pundit.policy(user, source_record)
        relationship_method = "add_to_#{relationship_type}?"
        allowed = if policy.respond_to?(relationship_method)
                    policy.send(relationship_method, new_related_records)
                  else
                    policy.update?
                  end
        raise ::Pundit::NotAuthorizedError unless allowed
      end

      def replace_to_many_relationship(source_record, new_related_records, relationship_type)
        policy = ::Pundit.policy(user, source_record)
        relationship_method = "replace_#{relationship_type}?"
        allowed = if policy.respond_to?(relationship_method)
                    policy.send(relationship_method, new_related_records)
                  else
                    policy.update?
                  end
        raise ::Pundit::NotAuthorizedError unless allowed
      end

      def remove_to_many_relationship(source_record, related_record, relationship_type)
        policy = ::Pundit.policy(user, source_record)
        relationship_method = "remove_from_#{relationship_type}?"
        allowed = if policy.respond_to?(relationship_method)
                    policy.send(relationship_method, related_record)
                  else
                    policy.update?
                  end
        raise ::Pundit::NotAuthorizedError unless allowed
      end

      def remove_to_one_relationship(source_record, relationship_type)
        policy = ::Pundit.policy(user, source_record)
        relationship_method = "remove_#{relationship_type}?"
        allowed = if policy.respond_to?(relationship_method)
                    policy.send(relationship_method)
                  else
                    policy.update?
                  end
        raise ::Pundit::NotAuthorizedError unless allowed
      end
    end
  end
end