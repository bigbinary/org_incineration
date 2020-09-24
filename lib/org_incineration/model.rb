# frozen_string_literal: true

module OrgIncineration
  class Model
    include TSort

    def initialize
      @requirements = Hash.new { |h, k| h[k] = [] }
    end

    def add_requirement(name, requirement_dependencies)
      @requirements[name] = requirement_dependencies
    end

    def tsort_each_node(&block)
      @requirements.each_key(&block)
    end

    def tsort_each_child(name, &block)
      @requirements[name].each(&block) if @requirements.has_key?(name)
    end
  end
end
