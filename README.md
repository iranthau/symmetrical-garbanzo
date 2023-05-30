# Symmetrical Garbanzo

This is a demonstration project that can handle different payloads in different formats through the same endpoint.

## Run the project
1. Clone the project into your computer.
2. Run the following command:
```
docker-compose run -p 3000:3000 web bash
# Command does the following things:
# give you access to a running docker container
# Open port 3000 on web service
# spin up all the services such as a Postgres db instance, and a background job processor using sidekiq
```
3. Run the migrations:
```
rails db:setup
# This command will create the database and load the schema
```
3. Now you can run the server to connect to the app:
```
rails s -b 0.0.0.0 # This will starts the rails server.
```
4. Connect to the endpoint using Postman.
```
# Endpoint is: http://localhost:3000/reservations
```
5. You can also import the the included Postman collection in the root directory.

## Running tests
To be able to run test, you need to have the database setup and migrated for the test environment. Run the following commands run tests.
```
docker-compose run web bash
RAILS_ENV=test rails db:migrate
RAILS_ENV=test bundle exec rspec <test file/folder name>
```

## These improvements could have been added with more time
1. Payload validator could be added
2. Phone numbers could be stored in a separate table

## Notes
1. The solutions runs on docker.
2. Have set up the project for following best practices.
3. Uses background processing to process payloads.
4. Use rspecs for testing and other libraries such as factorybot, ffaker.
5. Successfully process the AirBnb payload.
6. Booking.com payload is not implemented yet.

