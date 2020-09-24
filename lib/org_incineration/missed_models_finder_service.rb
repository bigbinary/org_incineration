# frozen_string_literal: true

module OrgIncineration
  class MissedModelsFinderService
    delegate :all_models, :configured_models, :skipped_models, to: :@config

    def initialize
      @config = DependencySpecification.new(Organization.new)
    end

    def get
      all_models - (configured_models + skipped_models)
    end
  end
end
