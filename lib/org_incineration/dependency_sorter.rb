# frozen_string_literal: true

require "tsort"

module OrgIncineration
  class DependencySorter
    def initialize(cyclic_dependencies)
      @cyclic_dependencies = cyclic_dependencies
    end

    def get
      m = Model.new

      all_models.each do |model|
        dependencies = find_dependencies(model)
        skipped_dependencies = if @cyclic_dependencies.keys.include? model
          @cyclic_dependencies[model]
        else
          []
        end
        m.add_requirement(model, dependencies - skipped_dependencies)
      end

      m.tsort.reverse.select do |m|
        # Make sure that only valid model classes are returned
        model = m.constantize rescue nil
        model && (model < ApplicationRecord)
      end
    end

    def find_dependencies(t)
      parent_models(t)
    end

    def all_models
      Rails.application.eager_load!
      ApplicationRecord.descendants.map { |class_name| sanitize_class_name(class_name) }
    end

    def parent_models(klass)
      klass.constantize.reflections.values
        .select { |x| x.class.to_s.include?("::Belong") }
        .map { |x| sanitize_class_name(x.class_name) }
    end

    private
      def sanitize_class_name(class_name)
        c_name = class_name.to_s
        c_name.start_with?("::") ? c_name[2, c_name.length - 2] : c_name
      end
  end
end
