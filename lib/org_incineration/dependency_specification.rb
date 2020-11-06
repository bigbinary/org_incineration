# frozen_string_literal: true

module OrgIncineration
  class DependencySpecification
    def initialize(organization)
      @org = organization
    end

    def all_models
      @_all_models ||= DependencySorter.new.all_models
    end

    def skipped_models
      @_skipped_models ||= Organization::SKIPPED_MODELS
    end

    # Special cases. Eg: Models that have habtm relationships
    # that have join tables on which foreign key contraints are specified
    def models_that_need_destroy
      Organization::MODELS_REQUIRE_DESTROY
    end

    def configured_models
      get.keys.map(&:to_s)
    end

    def get
      begin
        @_get ||= Organization.associated_models(@org.id)
      rescue NoMethodError
        raise IncinerableConcernNotIncluded, "IncinerableConcern not included in th Organization model."
      end
    end
  end
end
