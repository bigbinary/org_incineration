module OrgIncineration
  module Generators
    class SetupGenerator < Rails::Generators::Base

      def self.source_root
        File.dirname(__FILE__)
      end

      desc "This would create a incinerable_concern.rb file where you can add all the dependencies."
      def add_concern_file
        template("incinerable_concern.rb.erb", "app/models/concerns/incinerable_concern.rb")
        puts "IncinerableConcern concern added"
        puts "Please include IncinerableConcern within your Organization model."
      end

      desc "This would create a rake task which could be used to check if any model is missed from the incineration process."
      def add_rake_file
        template("incinerator.rake.erb", "lib/tasks/incinerator.rake")
        puts "check_for_missing_models rake task added"
      end
    end
  end
end

