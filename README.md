# OrgIncineration

This is a gem that is used to add the Organization's Incineration functionality in your application.
Incineration a nonreversible task, and it systematically incinerates all the records.

This gem injects rake task, background and concerns file to facilitate the incineration process.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'org_incineration'
```

And then execute:

    $ bundle install

Then run the generator:

    $ rails generate org_incineration:setup

This would add 3 files:
- app/models/concerns/incineratable_concern.rb
- app/jobs/organization_incineration_job.rb
- lib/tasks/incinerator.rake

Requirements:
- Application must have Organization model.
- Organization model must have enum status column with values [active, cancelled].
- Also to track the duration of cancelled organization the organization model must have cancelled_at:DateTime column which should set the DateTime at which the organization have been marked as cancelled.


## Usage
Modifing the `IncineratableConcern` file.
You need to set 2 constant variables and a method.

### Constants:

`SKIPPED_MODELS`: Assign the Array of model names in string which need to be skipped from the incineration process.

`MODELS_REQUIRE_DESTROY`: Normally the records are incinerated by `delete_all` command but if some models needs `destroy` then it needs to be mentioned here.

### Method:
`associated_models`: You need to mention all the relationships of all the models with Organization.
eg:
```
{
    "Payment": {
      joins: :invoice,
      where: ["organization_id =?", org_id]
    },
    "OrganizationUser": {
      joins: {},
      where: ["organization_id =?", org_id]
    },
    "Invoice": {
      joins: {},
      where: ["organization_id =?", org_id]
    }
}
```


Include the `IncineratableConcern` in your Organization model.

### Background Job

`OrganizationIncinerationJob` is added to the Jobs folder.
By deafult its using DelayedJob, according to the application you can change it to work with sidekiq.
Change `include Delayed::RecurringJob` => `self.queue_adapter = :sidekiq`

Also, this job runs daily at 12.30 am UTC.

Organization that are cancelled `30 days` before would be incinerated in this job.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bigbinary/org_incineration. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bigbinary/org_incineration/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OrgIncineration project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bigbinary/org_incineration/blob/master/CODE_OF_CONDUCT.md).
