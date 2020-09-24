# frozen_string_literal: true

module OrgIncineration
  class IncineratorService
    def initialize(organization)
      @org = organization
      ActiveRecord::Base.logger = nil
    end

    def run!
      delete_all_dependencies
      delete_organization
    end

    private

      def delete_organization
        puts "Deleting organization"
        @org.reload.delete
      end

      def delete_all_dependencies
        sorted_dependencies.each do |dependency|
          model_info = dependency_specification.get[dependency.to_sym]
          next unless model_info.present?

          if model_info.is_a?(Hash)
            incinerate! dependency, model_info
          else
            model_info.each do |m_info|
              incinerate! dependency, m_info
            end
          end
        end
      end

      def dependency_specification
        @_dependency_specification ||= DependencySpecification.new(@org)
      end

      def sorted_dependencies
        DependencySorter.new.get
      end

      def models_that_need_destroy
        dependency_specification.models_that_need_destroy
      end

      def incinerate!(_model, model_hash)
        puts "Incinerating #{_model}..."

        model   = _model.constantize
        records = model.joins(model_hash[:joins]).where(model_hash[:where])

        method = models_that_need_destroy.include?(_model) ? "destroy_all" : "delete_all"

        result = records.send(method)

        count = result.respond_to?(:count) ? result.count : result

        puts "----#{count} records deleted"
      end
  end
end