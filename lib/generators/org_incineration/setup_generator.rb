module OrgIncineration
  module Generators
    class SetupGenerator < Rails::Generators::Base

      def self.source_root
        File.dirname(__FILE__)
      end

      desc "This would create a incineratable_concern.rb file where you can add all the dependencies."
      def create_concern_file
        template("incineratable_concern.rb.erb", "app/models/concerns/incineratable_concern.rb")
        puts "Please include IncineratableConcern within your Organization model."
      end

      desc "This would create a rake task which could be used to check if any model is missed from the incineration process."
      def create_rake_file
        template("incinerator.rake.erb", "lib/tasks/incinerator.rake")
        puts "Setup completed!"
      end
    end
  end
end

