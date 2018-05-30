# BCG DV

Getting started
-----
First of all clone this repository:
````
git clone https://github.com/danbadge/bcg-dv
````

It's entirely up to you if you want to use Docker/Docker Compose or not, running the application or the tests should work either way.

### Without Docker
The app was built with Ruby version `2.5.1` but I also tested with `2.4.3`.

#### Install dependencies:
````
bundle install
````

#### Run all the tests:
````
bundle exec rspec
````

#### Run the application:
````
ruby app.rb
````

### With Docker
If you're interested, have a look at the [.scripts](.scripts) folder as there's some shortcuts for the following commands.

#### Run all the tests:
````
docker-compose run web-app bundle exec rspec
````

#### Run the application:
````
docker-compose up --build
````

### Making a request
Once you've got the application running you can test out and explore the API, here's an example:
````
curl http://localhost:8081/lines/M4
````

Notes / Improvements
-----

* I decided to keep things pretty simple, even starting with a really basic test and implementation which pushed me to implement CSV data retrieval returned as JSON via an API call.
* Continuing with that TDD approach from outside-in has led me to a place where I've got a lot of high-level, functional tests. One improvement might be to push some of these down and closer to the `lines_service`. Either way, I'm happy with the level of coverage.
* It took a while to understand what was required for `lines/:name` endpoint, I'm still unsure whether I've interpreted the document correctly.
* There's a little bit too much going on in `app.rb` still, it could be good to define some api helpers for response building, for example.
* I'm not overly happy with the dependencies between the methods `stop_ids_at_position`, `line_ids_at_stops_and_time` and `filter_lines_by` in `lines_service`. It all feels a bit too coupled with one read needed before the next retrieval and filter. Nor does extracting this file seem like a good enough separation of concerns, it was difficult to decide how granular to go. However, I'm not sure it would help readability too much more.