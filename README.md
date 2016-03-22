Serve the City Karlsruhe
========================

[![Dependency Status](https://gemnasium.com/matthias-g/stc-karlsruhe.svg)](https://gemnasium.com/matthias-g/stc-karlsruhe)

This is the software running at [servethecity-karlsruhe.de](https://servethecity-karlsruhe.de) used for managing
projects and volunteers during a project week of Serve the City Karlsruhe.
It's written using Ruby on Rails.

Do you want to improve this platform? Or do you want to start Serve the City in your city and are looking for a platform to use?
Please [contact us](https://servethecity-karlsruhe.de/kontakt) - we would love to share and work with you!


Development Setup
-----------------

*Shell commands for Ubuntu/Debian*

Install [RVM](https://rvm.io)
```shell
pg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
```

Install PostgreSQL
```shell
sudo apt-get install postgresql libpq-dev
```

Install [JS runtime](https://github.com/rails/execjs)
```shell
# For example:
sudo apt-get install nodejs
```

Install Ruby
```shell
rvm install ruby-2.2.3
```

Install Bundler
```shell
gem install bundler
```

Clone repository
```shell
git clone https://github.com/matthias-g/stc-karlsruhe.git
cd stc-karsruhe
```

Install gems
```shell
bundle install
```

Setup PostgreSQL
```shell
sudo -u postgres -i
psql -d postgres
postgres=# create role <<your username>> login createdb
```

Create databases
```shell
rake db:setup
```

Start server
```shell
rails s
```