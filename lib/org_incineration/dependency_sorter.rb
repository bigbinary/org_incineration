# frozen_string_literal: true

require "tsort"

module OrgIncineration
  class DependencySorter
    def get
      m = Model.new

      all_models.each do |model|
        m.add_requirement(model, find_dependencies(model))
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
      ApplicationRecord.descendants.map(&:to_s)
    end

    def parent_models(klass)
      klass.constantize.reflections.values.select { |x| x.class.to_s.include?("::Belong") }.map(&:class_name)
    end
  end
end
