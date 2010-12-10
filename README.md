Configuration
-----------

    cp config/database.yml.example config/database.yml
    cp config/mailer.yml.example config/mailer.yml

Edit config/mailer.yml

You can use your valid gmail username/password, or privode another smtp server

Generating Fake Data
-----------
  
    rake dev:build # which performs db:drop db:create db:migrate db:seed
    rake dev:fake # generates a lot of fake data

The registeration progress needs email confirmation. 

To simplify testing, rake dev:fake also generated an authenticated account for testing. 

You can login with email=tester@mail.com and password=123456

