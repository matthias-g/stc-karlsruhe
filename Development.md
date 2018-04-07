After changing the fixtures run the following command to update the fixtures for the rspec tests.
```shell
$ RAILS_ENV=test rails db:fixtures:load
```

Run mutant tests for a policy with
```shell
$ RAILS_ENV=test bundle exec mutant -r ./config/environment --use rspec 'ApplicationPolicy'
```