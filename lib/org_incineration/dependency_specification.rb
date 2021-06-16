# frozen_string_literal: true

module OrgIncineration
  class DependencySpecification
    def initialize(organization)
      @org = organization
    end

    def all_models
      @_all_models ||= DependencySorter.new(cyclic_dependencies).all_models
    end

    def skipped_models
      @_skipped_models ||= Organization::SKIPPED_MODELS
    end

    # Special cases. Eg: Models that have habtm relationships
    # that have join tables on which foreign key contraints are specified
    def models_that_need_destroy
      Organization::MODELS_REQUIRE_DESTROY
    end

    # Special cases. Eg: Models that have cyclic relationships between each other.
    # class Organization
    #   has_many :users
    #   belongs_to :creator, class_name: "User", optional: true
    # end
    #
    # In the above case, the Organization and User models are cyclically related to each other.
    def cyclic_dependencies
      Organization::CYCLIC_DEPENDENCIES
    end

    def configured_models
      get.keys.map(&:to_s)
    end

    def get
      begin
        @_get ||= Organization.associated_models(@org.id)
      rescue NoMethodError
        raise IncinerableConcernNotIncluded, "IncinerableConcern not included in the Organization model."
      end
    end
  end
end
