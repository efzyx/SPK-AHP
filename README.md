# Sistem Pendukung Keputusan metode AHP

## How to Install
  - git clone `https://github.com/fauzipadlaw/spk-ahp.git`
  - `cd spk-ahp && bundle install`
  - configure database in `config/database.yml`
  - run `rails db:create`
  - run `rails db:migrate`
  - run `rails db:seed`
  - run `rails s`
  - Open `localhost:3000` on your browser


## Ruby
    Tested on ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]

## Database
    Tested on mysql  Ver 15.1 Distrib 10.1.32-MariaDB, for Linux (x86_64) using readline 5.1

## Gem
    gem "rails-assets-adminlte"
    gem 'bootstrap-sass'
    gem 'font-awesome-sass'
    gem 'chartkick'
    gem 'devise'
    gem 'icheck-rails'
