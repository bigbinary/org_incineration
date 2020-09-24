module OrgIncineration
  module Generators
    class SetupGenerator < Rails::Generators::Base

      def self.source_root
        File.dirname(__FILE__)
      end

      desc "This would create a incineratable_concern.rb file where you can add all the dependencies."
      def add_concern_file
        template("incineratable_concern.rb.erb", "app/models/concerns/incineratable_concern.rb")
        puts "IncineratableConcern concern added"
        puts "Please include IncineratableConcern within your Organization model."
      end

      desc "This would create a rake task which could be used to check if any model is missed from the incineration process."
      def add_rake_file
        template("incinerator.rake.erb", "lib/tasks/incinerator.rake")
        puts "check_for_missing_models rake task added"
      end

      desc "This would create a job for organization incineration which would run daily."
      def add_incineration_job_file
        template("organization_incineration_job.rb.erb", "app/jobs/organization_incineration_job.rb")
        puts "OrganizationIncinerationJob added."
        puts "Setup completed!"
      end
    end
  end
end
